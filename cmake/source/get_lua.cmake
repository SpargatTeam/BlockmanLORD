##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(LUA_ROOT "${CMAKE_SOURCE_DIR}/source/lua")
if(NOT EXISTS ${LUA_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${LUA_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET blord_lua)
    add_subdirectory(${LUA_ROOT} ${CMAKE_BINARY_DIR}/blord_lua_build)
endif()
include_directories(${LUA_ROOT})
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE blord_lua)