##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(LUA_ROOT "${CMAKE_SOURCE_DIR}/source/lua")
add_subdirectory(${LUA_ROOT} ${CMAKE_BINARY_DIR}/blord_lua_build)
include_directories(${LUA_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_lua)