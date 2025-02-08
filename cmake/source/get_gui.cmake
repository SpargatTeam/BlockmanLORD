##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(GUI_ROOT "${CMAKE_SOURCE_DIR}/source/gui")
add_subdirectory(${GUI_ROOT} ${CMAKE_BINARY_DIR}/blord_gui_build)
include_directories(${GUI_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_gui)