/********************************************************************
author: Comical
company: Spargat
*********************************************************************/
#include <sys/types.h>
#ifdef _WIN32 && _WIN64
    #include <windows.h>
#else
    #include <dirent.h>
#endif

#include <unistd.h>
#include <sys/stat.h>
#include <cstring>
#include <cstdint>
#include "Level.h"
#include "Map.h"
#include "entity/Player.h"
#include "nbt/NBT_Debug.h"
#include "nbt/NBT.h"
#include "nbt/NBT_Tag_Compound.h"

#include "ioaccess/IOAccess.h"
#include "rapidjson/document.h"

Level::Level() : level_nbt(0)
{
	NBT_Debug("new Level");
}

Level::~Level()
{
	NBT_Debug("delete Level");
	
	if(level_nbt)
		NBT_Debug("deleting level NBT");
	
	delete level_nbt;
	level_nbt = 0;

	for(auto &map: maps_)
	{
		delete map;
	}

	maps_.clear();
	
	for(auto &json: jsonDocCache_)
	{
		delete json.second;
	}
	
	jsonDocCache_.clear();
}

bool Level::load(const std::string &path)
{
	NBT_Debug("begin");
	
	std::string level_dat_path = path + "/level.dat";
	
	IOAccess::StatInfo si;
	if(!IOAccess::Stat(level_dat_path, &si))
	{
		NBT_Warn("No level.dat found, not a valid level!");
		return false;
	}
	
	NBT *nbt = new NBT;
	if(!nbt->load(level_dat_path))
	{
		NBT_Error("failed to load level.dat!");
		delete nbt;
		return false;
	}
	
	if(!dimensionScan(path))
	{
		NBT_Debug("failed dimension scan");
		delete nbt;
		return false;
	}
	
	path_ = path;
	
	for(auto &map: maps_)
	{
		if(!map->load())
		{
			NBT_Error("failed to load dimension at %s", map->mapPath().c_str());
		}
	}

	level_nbt = nbt;
	
	NBT_Debug("end");
	return true;
}

Map *Level::getMap(int id)
{
	for(auto map: maps_)
	{
		if(map->dimension() == id)
			return map;
	}

	return nullptr;
}

Map *Level::getMap(const std::string &name)
{
	for(auto map: maps_)
	{
		if(map->mapName() == name)
			return map;
	}

	return nullptr;
}


struct DirPair
{
	DirPair(const std::string &name, const std::string &path, IOAccess::Directory *dh) : name(name), path(path), dir(dh) { }
	std::string name;
	std::string path;
	IOAccess::Directory *dir;
};

bool Level::dimensionScan(const std::string &path)
{
	NBT_Debug("begin %s", path.c_str());
	
	IOAccess::Directory *dir = IOAccess::OpenDirectory(path);
	if(!dir)
	{
		NBT_Error("failed to open level directory for dimension scan.");
		return false;
	}

	std::vector<DirPair> dir_queue;

	// complicated shenanigans to locate all dimensions
	// various server mods like bukkit don't agree on dimension locations
	// instead of hardcoding support for layouts, just do a breadth first search
	// for .mca files.

	DirPair dp("unk", path, dir);
	bool load_players = false;
	Map *curMap = 0;
	std::string mapName;

	while(1)
	{
		
		std::string ent;
		// while the current dir list is at the end
		while(!dp.dir->read(&ent))
		{
			if(!dir_queue.empty())
			{
				load_players = false;
				delete dp.dir;
				dp = dir_queue.back();
				dir_queue.pop_back();
				//continue;
				//dp.dir->read(&ent);
				if(dp.dir->read(&ent))
					break;
			}
			else
				// escape if the queue is empty
				goto ESCAPE;
		}

		// skip hidden files
		if(ent[0] == '.')
			continue;
		
		std::string fpath = dp.path;
		if (fpath.back() != '/' && fpath.back() != '\\')
			fpath += "/";
		
		fpath += ent;
		
		// TODO: Find the source of why the hell this is happening, because it shouldn't.
		if (ent.size() == 0)
			continue;

		NBT_Debug("scan ent: %s", fpath.c_str());
		
		IOAccess::StatInfo si;
		if(!IOAccess::Stat(fpath, &si))
		{	// skip entries we can't stat
			NBT_Debug("failed to stat %s", fpath.c_str());
			continue;
		}

		if(si.isDir() && si.isExecutable())
		{
			// is a directory, and is listable
			
			IOAccess::Directory *dir = IOAccess::OpenDirectory(fpath);
		
			// skip if we can't list it
			if(!dir)
				continue;

			NBT_Debug("scan dir: %s", fpath.c_str());
			if(strcasecmp(ent.c_str(), "players") == 0)
				load_players = true;

			dir_queue.push_back(dp);
			dp.dir = dir;
			dp.path = fpath;
			dp.name = ent;
			//NBT_Debug("entering %s", fpath.c_str());
		}
		else
		{
			const char *ext = ent.c_str()+ent.find_last_of(".");

			NBT_Debug("scan: %s ext:%s", fpath.c_str(), ext);
			if(load_players)
			{
				
				if(ext && strcasecmp(ext, ".dat") == 0)
				{
					NBT_Debug("found player at %s", fpath.c_str());
					Player *player = new Player(fpath);
					if(!player->load())
					{
						NBT_Error("failed to load player nbt data at %s", fpath.c_str());
						continue;
					}

					players_.push_back(player);
				}
			}
			else
			{
				if(ext && strcasecmp(ext, ".mca") == 0)
				{
					NBT_Debug("found region at %s", fpath.c_str());
					
					DirPair parent_dp = dir_queue.back();

					Map *map = curMap = new Map(dp.path);
					maps_.push_back(map);

					delete dp.dir;
					dp = parent_dp;
					dir_queue.pop_back();
					continue;
				}
			}
		}
	}

ESCAPE:
	NBT_Debug("end");
	//delete dp.dir;
	delete dir;
	return true;
}

std::string Level::levelName()
{
	return level_nbt->getString("LevelName");
}

std::vector<Player *> Level::dimensionPlayers(int32_t dim)
{
	std::vector<Player *> list;

	for(auto &player: players_)
	{
		if(player->dimension() == dim)
			list.push_back(player);
	}

	return list;
}

int32_t Level::spawnX() { return level_nbt->getInt("SpawnX"); }
int32_t Level::spawnY() { return level_nbt->getInt("SpawnY"); }
int32_t Level::spawnZ() { return level_nbt->getInt("SpawnZ"); }
		