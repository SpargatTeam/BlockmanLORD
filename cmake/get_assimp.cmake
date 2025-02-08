##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(ASSIMP_DIR ${CMAKE_SOURCE_DIR}/libs/assimp)
add_subdirectory(${ASSIMP_DIR} ${CMAKE_BINARY_DIR}/assimp_build)
set(ASSIMP_BUILD_ZLIB OFF CACHE BOOL "Use system zlib" FORCE)
target_include_directories(${PROJECT_NAME} PRIVATE
    ${ASSIMP_DIR}/include
    ${ASSIMP_DIR}/code
)
target_link_libraries(${PROJECT_NAME} PRIVATE assimp)