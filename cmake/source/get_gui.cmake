##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(GUI_ROOT "${CMAKE_SOURCE_DIR}/source/gui")
if(NOT EXISTS ${GUI_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${GUI_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET blord_gui)
    add_subdirectory(${GUI_ROOT} ${CMAKE_BINARY_DIR}/blord_gui_build)
    include_directories(${GUI_ROOT})
    target_link_libraries(${PROJECT_NAME} PRIVATE blord_gui)
endif()
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()