##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
cmake_minimum_required(VERSION 3.15)
project(blord_gui)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
file(GLOB_RECURSE SOURCE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/*.h
)
add_library(${PROJECT_NAME} STATIC ${SOURCE_FILES})
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
### depencies
## imgui
if(BLORD_MODEL STREQUAL "gl")
    set(USE_GL ON)
elseif(BLORD_MODEL STREQUAL "gles")
    set(USE_GLES ON)
elseif(BLORD_MODEL STREQUAL "vk")
    set(USE_VK ON)
elseif(BLORD_MODEL STREQUAL "d3d")
    set(USE_D3D ON)
elseif(BLORD_MODEL STREQUAL "m")
    set(USE_M ON)
else()
    message(FATAL_ERROR "BLORD_MODEL is not valid!")
endif()
include(get_imgui)