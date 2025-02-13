##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(PHYSX_ROOT "${CMAKE_SOURCE_DIR}/libs/physx")
if(NOT EXISTS ${PHYSX_ROOT}/physx)
    message(STATUS "PhysX nu a fost găsit. Se clonează din repository...")
    execute_process(
        COMMAND git clone --recursive https://github.com/NVIDIAGameWorks/PhysX ${PHYSX_ROOT}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/libs
    )
    execute_process(
        COMMAND git submodule update --init --recursive
        WORKING_DIRECTORY ${PHYSX_ROOT}
    )
endif()
if(NOT EXISTS ${PHYSX_ROOT}/physx/source)
    message(FATAL_ERROR "Eroare: Directorul ${PHYSX_ROOT} nu conține sursele PhysX!")
endif()
if(NOT TARGET PhysX)
    option(PHYSX_BUILD_SHARED "Build PhysX as shared library" OFF)
    option(PHYSX_GENERATE_STATIC_LIBRARIES "Generate static libraries" ON)
    option(PX_SUPPORT_PVD "Enable PhysX Visual Debugger support" OFF)
    add_subdirectory(${PHYSX_ROOT}/physx/compiler/public ${CMAKE_BINARY_DIR}/physx_build)
    include_directories(
        ${PHYSX_ROOT}/pxshared/include
        ${PHYSX_ROOT}/physx/include
        ${PHYSX_ROOT}/physx/source/common/src
        ${PHYSX_ROOT}/physx/source/geomutils/src
        ${PHYSX_ROOT}/physx/source/physx/src
        ${PHYSX_ROOT}/physx/source/lowlevel/common/include
        ${PHYSX_ROOT}/physx/source/lowlevel/api/include
    )
    target_link_libraries(${PROJECT_NAME} PRIVATE PhysX PhysXCommon PhysXExtensions PhysXPvdSDK)
endif()
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()