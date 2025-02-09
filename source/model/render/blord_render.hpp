#ifndef MESH_DATA_HPP
#define MESH_DATA_HPP
#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <fstream>
struct MeshData {
    std::vector<float> vertices;
    std::vector<unsigned int> indices;
    std::vector<float> normals;
    std::vector<float> uvs;
    std::vector<std::string> textures;
};
inline MeshData parse3DData(const std::string& data) {
    MeshData meshData;
    std::istringstream stream(data);
    std::string line;
    while (std::getline(stream, line)) {
        if (line.find("vertices:") != std::string::npos) {
            while (std::getline(stream, line) && !line.empty()) {
                std::istringstream vertexStream(line);
                float vertex;
                while (vertexStream >> vertex) {
                    meshData.vertices.push_back(vertex);
                    if (vertexStream.peek() == ',') {
                        vertexStream.ignore();
                    }
                }
            }
        }
    }
    while (std::getline(stream, line)) {
        if (line.find("indices:") != std::string::npos) {
            while (std::getline(stream, line) && !line.empty()) {
                std::istringstream indexStream(line);
                unsigned int index;
                while (indexStream >> index) {
                    meshData.indices.push_back(index);
                    if (indexStream.peek() == ',') {
                        indexStream.ignore();
                    }
                }
            }
        }
    }
    while (std::getline(stream, line)) {
        if (line.find("normals:") != std::string::npos) {
            while (std::getline(stream, line) && !line.empty()) {
                std::istringstream normalStream(line);
                float normal;
                while (normalStream >> normal) {
                    meshData.normals.push_back(normal);
                    if (normalStream.peek() == ',') {
                        normalStream.ignore();
                    }
                }
            }
        }
    }
    while (std::getline(stream, line)) {
        if (line.find("uvs:") != std::string::npos) {
            while (std::getline(stream, line) && !line.empty()) {
                std::istringstream uvStream(line);
                float uv;
                while (uvStream >> uv) {
                    meshData.uvs.push_back(uv);
                    if (uvStream.peek() == ',') {
                        uvStream.ignore();
                    }
                }
            }
        }
    }
    while (std::getline(stream, line)) {
        if (line.find("textures:") != std::string::npos) {
            while (std::getline(stream, line) && !line.empty()) {
                meshData.textures.push_back(line);
            }
        }
    }
    return meshData;
}
inline void renderMesh(const MeshData& meshData) {
    std::cout << "Rendering Mesh..." << std::endl;
    std::cout << "Vertices: " << meshData.vertices.size() / 3 << " vertices." << std::endl;
    std::cout << "Indices: " << meshData.indices.size() / 3 << " triangles." << std::endl;
    std::cout << "Normals: " << meshData.normals.size() / 3 << " normals." << std::endl;
    std::cout << "UVs: " << meshData.uvs.size() / 2 << " texture coordinates." << std::endl;
    std::cout << "Textures: " << meshData.textures.size() << " textures." << std::endl;
    // TODO: Implement for every 3d current platform
}
#endif