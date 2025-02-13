##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(BULLET_ROOT "${CMAKE_SOURCE_DIR}/libs/bullet")
if(NOT EXISTS ${BULLET_ROOT}/CMakeLists.txt)
    message(STATUS "Bullet nu a fost găsit. Se clonează din repository...")
    execute_process(
        COMMAND git clone https://github.com/bulletphysics/bullet3 ${BULLET_ROOT}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/libs
    )
endif()
if(NOT EXISTS ${BULLET_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${BULLET_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET Bullet3Common)
    add_subdirectory(${BULLET_ROOT} ${CMAKE_BINARY_DIR}/bullet_build)
    include_directories(${BULLET_ROOT}/src)
    target_link_libraries(${PROJECT_NAME} PRIVATE BulletDynamics BulletCollision LinearMath)
endif()
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()