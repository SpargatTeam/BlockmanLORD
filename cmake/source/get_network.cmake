##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(NETWORK_ROOT "${CMAKE_SOURCE_DIR}/source/network")
if(NOT EXISTS ${NETWORK_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${NETWORK_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET blord_network)
    add_subdirectory(${NETWORK_ROOT} ${CMAKE_BINARY_DIR}/blord_network_build)
endif()
include_directories(${NETWORK_ROOT})
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE blord_network)