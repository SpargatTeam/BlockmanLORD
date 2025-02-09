##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(WORLD_ROOT "${CMAKE_SOURCE_DIR}/source/world")
if(NOT EXISTS ${WORLD_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${WORLD_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET blord_world)
    add_subdirectory(${WORLD_ROOT} ${CMAKE_BINARY_DIR}/blord_world_build)
    include_directories(${WORLD_ROOT})
    target_link_libraries(${PROJECT_NAME} PRIVATE blord_world)
endif()
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()