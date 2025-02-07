##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
cmake_minimum_required(VERSION 3.30)
project(blord_model)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
file(GLOB_RECURSE SOURCE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/render/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/render/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/render/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/render/*.h
)
add_library(${PROJECT_NAME} STATIC ${SOURCE_FILES})
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
# depencies
## cpm
include(get_cpm)
## opengl 
include(get_opengl)
## opengl es
#include(get_gles) # TODO:Fix me later
## directx
#include(get_dx)
## vulkan
include(get_vulkan)
## ogre
#set(USE_OPENGL ON)
#set(USE_GLES ON)
#set(USE_DIRECTX ON)
#set(USE_VULKAN ON)
#include(get_ogre)
## assimp
include(get_assimp)