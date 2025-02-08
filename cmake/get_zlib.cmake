##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
if(UNIX AND NOT APPLE)
    set(ZLIB_ROOT "${CMAKE_SOURCE_DIR}/libs/zlib")
    add_subdirectory(${ZLIB_ROOT} ${CMAKE_BINARY_DIR}/zlib_build)
    include_directories(${ZLIB_ROOT})
    target_link_libraries(${PROJECT_NAME} PRIVATE zlib)
else()
    message(STATUS "Zlib not needed.")
endif()