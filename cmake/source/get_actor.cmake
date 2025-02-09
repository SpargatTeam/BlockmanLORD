##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(ACTOR_ROOT "${CMAKE_SOURCE_DIR}/source/actor")
if(NOT EXISTS ${ACTOR_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${ACTOR_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET blord_actor)
    add_subdirectory(${ACTOR_ROOT} ${CMAKE_BINARY_DIR}/blord_actor_build)
endif()
include_directories(${ACTOR_ROOT})
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE blord_actor)