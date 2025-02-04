##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(IMGUI_DIR ${CMAKE_SOURCE_DIR}/libs/imgui)
target_include_directories(${PROJECT_NAME} PRIVATE
    ${IMGUI_DIR}
    ${IMGUI_DIR}/backends
)
target_sources(${PROJECT_NAME} PRIVATE
    ${IMGUI_DIR}/imgui.cpp
    ${IMGUI_DIR}/imgui_draw.cpp
    ${IMGUI_DIR}/imgui_widgets.cpp
    ${IMGUI_DIR}/imgui_tables.cpp
    ${IMGUI_DIR}/imgui_demo.cpp
)
if(USE_OPENGL)
    target_sources(${PROJECT_NAME} PRIVATE
        ${IMGUI_DIR}/backends/imgui_impl_glfw.cpp
        ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
    )
    target_compile_definitions(${PROJECT_NAME} PRIVATE IMGUI_IMPL_OPENGL_LOADER_GLAD)
    include(get_opengl)
endif()
#if(USE_GLES)
#    target_sources(${PROJECT_NAME} PRIVATE
#        ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
#    )
#    target_compile_definitions(${PROJECT_NAME} PRIVATE IMGUI_IMPL_OPENGL_ES3)
#    include(get_gles)
#endif()
if(USE_DIRECTX)
    target_sources(${PROJECT_NAME} PRIVATE
        ${IMGUI_DIR}/backends/imgui_impl_dx11.cpp
    )
    include(get_dx)
endif()
if(USE_VULKAN)
    target_sources(${PROJECT_NAME} PRIVATE
        ${IMGUI_DIR}/backends/imgui_impl_vulkan.cpp
    )
    include(get_vulkan)
endif()