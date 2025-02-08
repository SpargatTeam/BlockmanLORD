##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(ACTOR_ROOT "${CMAKE_SOURCE_DIR}/source/actor")
add_subdirectory(${ACTOR_ROOT} ${CMAKE_BINARY_DIR}/blord_actor_build)
include_directories(${ACTOR_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_actor)