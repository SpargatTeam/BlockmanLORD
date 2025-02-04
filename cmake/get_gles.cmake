##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
find_package(OpenGLES REQUIRED)
if(NOT TARGET OpenGLES::GLES)
  message(FATAL_ERROR "OpenGLES::GLES target not found. Ensure OpenGL ES is installed.")
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE OpenGLES::GLES)