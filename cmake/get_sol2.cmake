##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(SOL2_ROOT "${CMAKE_SOURCE_DIR}/libs/sol2")
if(NOT EXISTS ${SOL2_ROOT}/CMakeLists.txt)
    message(STATUS "sol2 nu a fost găsit. Se clonează din repository...")
    execute_process(
        COMMAND git clone --recursive https://github.com/ThePhD/sol2 ${SOL2_ROOT}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/libs
    )
endif()
if(NOT EXISTS ${SOL2_ROOT}/include/sol/sol.hpp)
    message(FATAL_ERROR "Eroare: Directorul ${SOL2_ROOT} nu conține fișierul sol.hpp!")
endif()
if(NOT TARGET sol2)
    include_directories(${SOL2_ROOT}/include)
endif()
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()