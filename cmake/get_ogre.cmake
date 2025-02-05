##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(OGRE_DIR ${CMAKE_SOURCE_DIR}/libs/ogre)
set(OGRE_BUILD_DEPENDENCIES ON)
set(OGRE_BUILD_SAMPLES OFF)
set(OGRE_BUILD_RENDERSYSTEM_CG OFF CACHE BOOL "" FORCE)
set(OGRE_BUILD_TESTS OFF)
set(OGRE_STATIC ON CACHE BOOL "" FORCE)
add_subdirectory(${OGRE_DIR} ${CMAKE_BINARY_DIR}/ogre_build)
target_include_directories(${PROJECT_NAME} PRIVATE
    ${OGRE_DIR}/OgreMain/include
    ${OGRE_DIR}/Components
    ${OGRE_DIR}/RenderSystems
)
target_link_libraries(${PROJECT_NAME} PRIVATE
    OgreMain
    OgreOverlay
    OgrePaging
    OgreProperty
    OgreRTShaderSystem
    OgreTerrain
    OgreVolume
)
if(USE_OPENGL)
    include(get_glfw)
    include(get_opengl)
    target_compile_definitions(${PROJECT_NAME} PRIVATE OGRE_CONFIG_RENDER_SYSTEM_GL3Plus)
    target_link_libraries(${PROJECT_NAME} PRIVATE OgreGL3Plus)
endif()
if(USE_GLES)
    include(get_gles)
    target_compile_definitions(${PROJECT_NAME} PRIVATE OGRE_CONFIG_RENDER_SYSTEM_GLES2)
    target_link_libraries(${PROJECT_NAME} PRIVATE OgreGLES2)
endif()
if(USE_DIRECTX)
    include(get_dx)
    target_compile_definitions(${PROJECT_NAME} PRIVATE OGRE_CONFIG_RENDER_SYSTEM_D3D11)
    target_link_libraries(${PROJECT_NAME} PRIVATE OgreD3D11)
endif()
if(USE_VULKAN)
    include(get_vulkan)
    target_compile_definitions(${PROJECT_NAME} PRIVATE OGRE_CONFIG_RENDER_SYSTEM_VULKAN)
    target_link_libraries(${PROJECT_NAME} PRIVATE OgreVulkan)
endif()