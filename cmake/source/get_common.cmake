##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(COMMON_ROOT "${CMAKE_SOURCE_DIR}/source/model")
add_subdirectory(${COMMON_ROOT} ${CMAKE_BINARY_DIR}/blord_common_build)
include_directories(${COMMON_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_common)