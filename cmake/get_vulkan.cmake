##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
find_package(Vulkan REQUIRED)
if(NOT TARGET Vulkan::Vulkan)
  message(FATAL_ERROR "Vulkan::Vulkan target not found. Ensure Vulkan SDK is installed.")
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE Vulkan::Vulkan)