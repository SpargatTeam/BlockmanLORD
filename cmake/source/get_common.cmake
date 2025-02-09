##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(COMMON_ROOT "${CMAKE_SOURCE_DIR}/source/common")
if(NOT EXISTS ${COMMON_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${COMMON_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET blord_common)
    add_subdirectory(${COMMON_ROOT} ${CMAKE_BINARY_DIR}/blord_common_build)
    include_directories(${COMMON_ROOT})
    target_link_libraries(${PROJECT_NAME} PRIVATE blord_common)
endif()
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()