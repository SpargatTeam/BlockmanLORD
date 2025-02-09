##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(ASSIMP_DIR ${CMAKE_SOURCE_DIR}/libs/assimp)
set(ASSIMP_BINARY_DIR "${CMAKE_BINARY_DIR}/assimp_build")
if(NOT TARGET assimp)
    add_subdirectory(${ASSIMP_DIR} ${ASSIMP_BINARY_DIR})
endif()
target_include_directories(${PROJECT_NAME} PRIVATE
    ${ASSIMP_DIR}/include
)
target_link_libraries(${PROJECT_NAME} PRIVATE assimp)