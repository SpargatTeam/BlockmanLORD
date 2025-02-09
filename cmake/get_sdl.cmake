##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(SDL_ROOT "${CMAKE_SOURCE_DIR}/libs/sdl")
if(NOT EXISTS ${SDL_ROOT}/CMakeLists.txt)
    message(STATUS "SDL nu a fost găsit. Se clonează din repository...")
    execute_process(
        COMMAND git clone https://github.com/libsdl-org/SDL ${SDL_ROOT}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/libs
    )
endif()
if(NOT EXISTS ${SDL_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${SDL_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET SDL2)
    add_subdirectory(${SDL_ROOT} ${CMAKE_BINARY_DIR}/sdl_build)
    include_directories(${SDL_ROOT}/include)
    target_link_libraries(${PROJECT_NAME} PRIVATE SDL2)
endif()
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()