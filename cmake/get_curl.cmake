##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(CURL_ROOT "${CMAKE_SOURCE_DIR}/libs/curl")
if(NOT EXISTS ${CURL_ROOT}/CMakeLists.txt)
    message(STATUS "cURL nu a fost găsit. Se clonează din repository...")
    execute_process(
        COMMAND git clone https://github.com/curl/curl ${CURL_ROOT}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/libs
    )
endif()
if(NOT EXISTS ${CURL_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${CURL_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET libcurl)
    add_subdirectory(${CURL_ROOT} ${CMAKE_BINARY_DIR}/curl_build)
    include_directories(${CURL_ROOT}/include)
    target_link_libraries(${PROJECT_NAME} PRIVATE libcurl)
endif()
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()