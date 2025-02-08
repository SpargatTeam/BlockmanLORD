##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
cmake_minimum_required(VERSION 3.30)
project(blord_world)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
file(GLOB_RECURSE SOURCE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/*.h
)
add_library(${PROJECT_NAME} STATIC ${SOURCE_FILES})
target_include_directories(${PROJECT_NAME} PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/block
    ${CMAKE_CURRENT_SOURCE_DIR}/chunk
    ${CMAKE_CURRENT_SOURCE_DIR}/entity
    ${CMAKE_CURRENT_SOURCE_DIR}/ioaccess
    ${CMAKE_CURRENT_SOURCE_DIR}/level
    ${CMAKE_CURRENT_SOURCE_DIR}/map
    ${CMAKE_CURRENT_SOURCE_DIR}/model
    ${CMAKE_CURRENT_SOURCE_DIR}/NBT
    ${CMAKE_CURRENT_SOURCE_DIR}/rapidjson)
include(get_zlib)