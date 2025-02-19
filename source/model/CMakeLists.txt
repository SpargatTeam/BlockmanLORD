##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
cmake_minimum_required(VERSION 3.15)
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
### depencies
## cpm
include(get_cpm)
## 3d
if(BLORD_MODEL STREQUAL "gl")
    ## opengl
    include(get_gl)
    ## source
    file(GLOB_RECURSE MODEL_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/gl/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/gl/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/gl/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/gl/*.h
    )
    target_sources(${PROJECT_NAME} PRIVATE ${MODEL_SOURCE})
elseif(BLORD_MODEL STREQUAL "gles")
    ## opengl es
    include(get_gles)
    ## source
    file(GLOB_RECURSE MODEL_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/gles/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/gles/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/gles/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/gles/*.h
    )
    target_sources(${PROJECT_NAME} PRIVATE ${MODEL_SOURCE})
elseif(BLORD_MODEL STREQUAL "vk")
    ## vulkan
    include(get_vk)
    ## source
    file(GLOB_RECURSE MODEL_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/vk/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/vk/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/vk/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/vk/*.h
    )
    target_sources(${PROJECT_NAME} PRIVATE ${MODEL_SOURCE})
elseif(BLORD_MODEL STREQUAL "d3d")
    ## directx
    include(get_dx)
    ## source
    file(GLOB_RECURSE MODEL_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/d3d/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/d3d/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/d3d/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/d3d/*.h
    )
    target_sources(${PROJECT_NAME} PRIVATE ${MODEL_SOURCE})
elseif(BLORD_MODEL STREQUAL "m")
    ## metal
    include(get_m)
    ## source
    file(GLOB_RECURSE MODEL_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/m/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/m/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/m/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/m/*.h
    )
    target_sources(${PROJECT_NAME} PRIVATE ${MODEL_SOURCE})
else()
    message(FATAL_ERROR "BLORD_MODEL is not valid!")
endif()
## assimp
include(get_assimp)
## bullet
#include(get_bullet) # will be fixed later