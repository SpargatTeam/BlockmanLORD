##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(WORLD_ROOT "${CMAKE_SOURCE_DIR}/source/world")
add_subdirectory(${WORLD_ROOT} ${CMAKE_BINARY_DIR}/blord_world_build)
include_directories(${WORLD_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_world)