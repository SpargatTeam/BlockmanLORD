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
if(USE_GL)
    include(get_gl)
    target_sources(${PROJECT_NAME} PRIVATE
        ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
    )
endif()
if(USE_GLES)
    include(get_gles)
    target_sources(${PROJECT_NAME} PRIVATE
        ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
    )
    target_compile_definitions(${PROJECT_NAME} PRIVATE IMGUI_IMPL_OPENGL_ES3)
endif()
if(USE_D3D)
    include(get_dx)
    target_sources(${PROJECT_NAME} PRIVATE
        ${IMGUI_DIR}/backends/imgui_impl_dx11.cpp
    )
endif()
if(USE_VK)
    include(get_vk)
    target_sources(${PROJECT_NAME} PRIVATE
        ${IMGUI_DIR}/backends/imgui_impl_vulkan.cpp
    )
endif()
if(USE_M)
    include(get_metal)
    target_sources(${PROJECT_NAME} PRIVATE
        ${IMGUI_DIR}/backends/imgui_impl_metal.mm
    )
endif()