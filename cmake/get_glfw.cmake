##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(GLFW_DIR ${CMAKE_SOURCE_DIR}/libs/glfw)
add_subdirectory(${GLFW_DIR} ${CMAKE_BINARY_DIR}/glfw_build)
include_directories(${GLFW_DIR}/include)
target_link_libraries(${PROJECT_NAME} PRIVATE glfw)