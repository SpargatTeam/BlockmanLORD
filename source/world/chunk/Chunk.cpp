/********************************************************************
author: Comical
company: Spargat
*********************************************************************/
#include <cstdio>
#include <cassert>
#include <cmath>
#include "map/MCRegion.h"
#include "chunk/Chunk.h"
#include "util.hpp"

#include "nbt/NBT.h"
#include "nbt/NBT_Debug.h"
#include "nbt/NBT_File.h"
#include "nbt/NBT_Tag_Byte_Array.h"
#include "nbt/NBT_Tag_List.h"

#include "chunk/ChunkSection.h"
#include "block/BlockAddress.h"
#include "block/BlockInfo.h"

#include <zlib.h>

Chunk::Chunk(int t, int x, int z, int co, int cl) : x_pos(x), z_pos(z), timestamp(t), chunk_offset(co), chunk_len(cl), nbt_data(0)
{
	//NBT_Debug("new Chunk");
	memset(sections, 0, sizeof(sections));
}

Chunk::~Chunk()
{
	//NBT_Debug("delete Chunk");

	for(auto sec: sections)
		delete sec;
	
	delete nbt_data;
	nbt_data = 0;
}

#define DEST_BUFFER_SIZE (SECTOR_SIZE * 8)
bool Chunk::load(NBT_File *fh)
{
	//NBT_Debug("begin");
	
	uint32_t length = 0;
	uint8_t compression_type = 0;
	
	//NBT_Debug("begin");
	
	memset(sections, 0, sizeof(sections));
	
	if(!fh->read(&length))
	{
		NBT_Error("failed to read compressed chunk data length");
		return false;
	}
	
	if(!fh->read(&compression_type))
	{
		NBT_Error("failed to read chunk compression type");
		return false;
	}
	
	//NBT_Debug("chunk offset: %i, length: %i sectors, %i bytes (%u), type: %s", chunk_offset, chunk_len, length, swapped, compression_type == 1 ? "GZip" : "Zlib");
	
	if(compression_type == 1)
	{
		NBT_Warn("gzip compression type unsupported!\n");
		return false;
	}
	
	if(!fh->readCompressedMode(length-1))
	{
		NBT_Error("failed to enter compressed mode");
		return false;
	}
	
	nbt_data = (NBT_Tag_Compound *)NBT_Tag::LoadTag(fh);
	if(!nbt_data)
	{
		NBT_Error("failed to load root tag");
		return false;
	}
	
	if(!fh->endCompressedMode())
	{
		NBT_Error("failed to end compressed mode");
		return false;
	}
	
	if(nbt_data)
	{
		NBT_Tag_Compound *level_tag = nbt_data->getCompound("Level");
		if(!level_tag)
		{
			NBT_Error("chunk is missing Level tag");
			NBT_Debug("data: %s", nbt_data->serialize().c_str());
			goto chunk_load_bail;
		}
		
		x_pos = level_tag->getInt("xPos");
		z_pos = level_tag->getInt("zPos");
		//NBT_Debug("xpos: %i, zpos: %i", x_pos, z_pos);
		
		NBT_Tag_List *sections_tag = level_tag->getList("Sections");
		if(!sections_tag)
		{
			NBT_Error("chunk is missing Sections tag");
			m_section_count = 0;
		}
		else
		{
			m_section_count = sections_tag->count();
			//NBT_Debug("sections: %i", m_section_count);
			for(uint32_t section_id = 0; section_id < m_section_count; section_id++)
			{
				NBT_Tag_Compound *section_tag = (NBT_Tag_Compound*)sections_tag->itemAt(section_id);
				if(!section_tag)
				{
					NBT_Debug("section %i not found", section_id);
					continue;
				}
				
				ChunkSection *rcs = new ChunkSection();
				if(!rcs->init(section_id, section_tag))
				{
					NBT_Debug("failed to initialize ChunkSection(%i)", section_id);
					delete rcs;
					goto chunk_load_bail;
				}
				
				//NBT_Debug("section[%i,%i]: %p", section_id, rcs->y(), rcs);
				sections[rcs->y()] = rcs;
			}
		}
		
		biome_data = nbt_data->getByteArray("Biomes");
	}
	
	//NBT_Debug("end");
	
	return nbt_data != 0;
	
chunk_load_bail:
	for(int i = 0; i < MAX_SECTIONS; i++)
	{
		delete sections[i];
		sections[i] = nullptr;
	}
	
	if(nbt_data)
		delete nbt_data;
	
	nbt_data = nullptr;
	
	//NBT_Debug("end err");
	return false;
}

bool Chunk::save(NBT_File *fh)
{
	if(!fh->writeCompressedMode())
	{
		NBT_Error("failed to enter compressed mode");
		return false;
	}
	
	//uint32_t begin_pos = fh->tell();
	if(!nbt_data->writeTag(fh))
	{
		NBT_Error("failed to write nbt tag");
		fh->clearCompressedMode();
		return false;
	}
	
	if(!fh->endCompressedMode())
	{
		NBT_Error("failed to end compressed mode");
		fh->clearCompressedMode();
		return false;
	}

	//uint32_t end_pos = fh->tell();
	
	chunk_len = ceil((double)fh->lastWriteBufferLen() / (double)SECTOR_SIZE);
	
	//NBT_Debug("save chunk: begin_pos:%i, end_pos:%i, num chunks:%i (%i)", begin_pos, end_pos, chunk_len, fh->lastWriteBufferLen());
	
	
	return true;
}

uint32_t Chunk::sectionCount()
{
	return m_section_count;
}

ChunkSection* Chunk::getSection(uint32_t idx)
{
	if(idx >= m_section_count)
		return nullptr;
	
	return sections[idx];
}



bool Chunk::getBlockAddress(int32_t x, int32_t y, int32_t z, BlockAddress *addr)
{
	/*if((x / 16) != x_pos || (z_pos / 16) != z_pos)
	{
		// not in this chunk.
		NBT_Debug("addr: %i,%i :: %i,%i", x / 16, z / 16, x_pos, z_pos);
		return false;
	}*/
	
	*addr = BlockAddress(0, x, y, z);
	
	return true;
}

bool Chunk::getBlockInfo(const BlockAddress &addr, BlockInfo *info)
{
	if(addr.section < 0 || addr.section > MAX_SECTIONS)
		return false;
	
	ChunkSection *section = sections[addr.section];
	if(!section)
	{
		// a block in an empty section means its air. just short circuit.
		info->addr = addr;
		info->data = 0;
		info->id = 0;
		info->biome = BIOME_UNCALCULATED;
		info->state_name = "air_nsec";
		return true;
	}
	
	bool ret = section->getBlockInfo(addr, info);
	if(!ret)
		return false;
	
	if(biome_data)
	{
		uint8_t *data = biome_data->data();
		uint8_t idx = addr.lx * 16 + addr.lz;
		info->biome = data[idx];
	}
	
	return true;
}

