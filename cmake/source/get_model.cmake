##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(MODEL_ROOT "${CMAKE_SOURCE_DIR}/source/model")
add_subdirectory(${MODEL_ROOT} ${CMAKE_BINARY_DIR}/blord_model_build)
include_directories(${MODEL_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_model)