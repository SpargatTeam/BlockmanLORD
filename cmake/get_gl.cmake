##############################################################
#
# Made by Comical
# OpenGL setup for Blockman Launcher CMake
#
##############################################################
find_package(OpenGL REQUIRED)
if(NOT TARGET OpenGL::GL)
  message(FATAL_ERROR "OpenGL::GL target not found. Ensure OpenGL is properly installed.")
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE OpenGL::GL)