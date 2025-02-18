/********************************************************************
#                                                                   #
# author: Comical                                                   #
# company: Spargat                                                  #
#                                                                   #
*********************************************************************/
// BlockmanLORD imports
#include "blord_version.hpp"
#include "blord_config.hpp"
// common imports
#include <iostream>
#include <string>
#include <fstream>
using namespace std;
#ifdef _WIN32 & _WIN64
    #include "windows.h"
#endif
// imports boost
#include <boost/asio.hpp>
#include <boost/beast.hpp>
#include <memory>
namespace asio = boost::asio;
namespace beast = boost::beast;
namespace http = beast::http;
namespace websocket = beast::websocket;
using tcp = asio::ip::tcp;
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
int main() {
    // strings
    string name;
    string server;
    // print info
    cout << "BlockmanLORD Server" << endl << "Version " << BLORD_VERSION << endl << "Copyright (c) 2025 SpargatTeam" << endl << "All rights reserved." << endl << endl;
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
        cout << "BlockmanLORD Server runs on: ws://localhost:" << BLORD_GAMESERVER_PORT << endl;
        asio::io_context ioc;
        tcp::acceptor acceptor(ioc, {tcp::v4(), BLORD_GAMESERVER_PORT});
        tcp::socket socket(ioc);
        acceptor.async_accept(socket, [&](beast::error_code ec) {
            if (!ec) {
                websocket::stream<tcp::socket> ws(std::move(socket));
                ws.accept();
                beast::flat_buffer buffer;
                ws.read(buffer);
                ws.text(ws.got_text());
                ws.write(buffer.data());
            }
        });
        ioc.run();
        cout << server << "@" << name << ":~$ ";
        getline(cin, input);
        if (input == "exit") break;
    }
    return 0;
}