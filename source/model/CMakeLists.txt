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
### depencies
## cpm
include(get_cpm)
## 3d
if(BLORD_MODEL STREQUAL "d3d")
    ## directx
    include(get_dx)
    ## source
    file(GLOB_RECURSE MODEL_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/directx/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/directx/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/directx/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/directx/*.h
    )
    target_sources(${PROJECT_NAME} PRIVATE ${MODEL_SOURCE})
elseif(BLORD_MODEL STREQUAL "vk")
    ## vulkan
    include(get_vulkan)
    ## source
    file(GLOB_RECURSE MODEL_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/vulkan/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/vulkan/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/vulkan/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/vulkan/*.h
    )
    target_sources(${PROJECT_NAME} PRIVATE ${MODEL_SOURCE})
else()
    message(FATAL_ERROR "BLORD_MODEL is not valid!")
endif()
## assimp
include(get_assimp)
## physx
include(get_physx)