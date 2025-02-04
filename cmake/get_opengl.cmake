##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
find_package(OpenGL REQUIRED)
set(OpenGL_GL_PREFERENCE GLVND)
if(NOT TARGET OpenGL::GL)
  message(FATAL_ERROR "OpenGL::GL target not found. Ensure OpenGL is installed.")
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE OpenGL::GL)