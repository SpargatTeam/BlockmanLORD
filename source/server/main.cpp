/********************************************************************
#                                                                   #
# author: Comical                                                   #
# company: Spargat                                                  #
#                                                                   #
*********************************************************************/
// not now
//#include "blord.hpp"
#include "blord_server.hpp"
//using namespace BlockmanLORD;
#include <iostream>
#include <string>
#include <fstream>
using namespace std;
#ifdef _WIN32 && _WIN64
#include "windows.h"
#endif
// configs
const string CONFIG_FILE = "config.txt";
void saveConfig(const string& name, const string& server) {
    ofstream outFile(CONFIG_FILE);
    if (outFile) {
        outFile << name << endl;
        outFile << server << endl;
    }
}
void loadConfig(string& name, string& server) {
    ifstream inFile(CONFIG_FILE);
    if (inFile) {
        getline(inFile, name);
        getline(inFile, server);
    }
}
// main
int main()
{
    // strings
    string name;
    string server;
    // print info
    cout << "BlockmanLORD Server" << endl << "Version 10000" << endl << "Copyright (c) 2025 SpargatTeam" << endl << "All rights reserved." << endl << endl;
    // get info
    loadConfig(name, server);
    if (name.empty() || server.empty()) {
        cout << "User name: ";
        cin >> name;
        cout << "Server name: ";
        cin >> server;
        saveConfig(name, server);   
    }
    // console
    string input;
    while (true) {
        cout << server << "@" << name << ":~$";
        getline(cin, input);
        if (input == "exit") break;
    }
    return 0;
}