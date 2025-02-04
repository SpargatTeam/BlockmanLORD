##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
find_library(DIRECTX_LIB d3d10 d3d11 d3d12 PATHS "$ENV{WindowsSdkDir}/Lib" PATH_SUFFIXES "um/x64")
if(NOT DIRECTX_LIB)
  message(FATAL_ERROR "DirectX library not found. Ensure Windows SDK is installed.")
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE ${DIRECTX_LIB})