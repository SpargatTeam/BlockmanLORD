##############################################################
#
# Made by Comical
# Metal setup for Blockman Launcher CMake
#
##############################################################
find_package(Metal REQUIRED)
if(NOT TARGET Metal::Metal)
  message(FATAL_ERROR "Metal::Metal target not found. Ensure Metal is properly installed on macOS.")
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE Metal::Metal)