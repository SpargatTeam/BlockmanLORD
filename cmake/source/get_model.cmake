##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(MODEL_ROOT "${CMAKE_SOURCE_DIR}/source/model")
if(NOT EXISTS ${MODEL_ROOT}/CMakeLists.txt)
    message(FATAL_ERROR "Eroare: Directorul ${MODEL_ROOT} nu conține un CMakeLists.txt!")
endif()
if(NOT TARGET blord_model)
    add_subdirectory(${MODEL_ROOT} ${CMAKE_BINARY_DIR}/blord_model_build)
    include_directories(${MODEL_ROOT})
    target_link_libraries(${PROJECT_NAME} PRIVATE blord_model)
endif()
if(NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "Eroare: PROJECT_NAME nu este definit! Setează-l înainte de a include acest fișier.")
endif()