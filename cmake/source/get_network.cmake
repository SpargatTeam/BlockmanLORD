##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(NETWORK_ROOT "${CMAKE_SOURCE_DIR}/source/network")
add_subdirectory(${NETWORK_ROOT} ${CMAKE_BINARY_DIR}/blord_network_build)
include_directories(${NETWORK_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_network)