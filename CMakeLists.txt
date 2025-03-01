##############################################################
#                                                            #
# Made by Comical                                            #
# BlockmanLORD of Blockman Launcher CMake                    #
#                                                            #
##############################################################
### CMake
cmake_minimum_required(VERSION 3.15)
if(NOT BLORD_BUILD OR 
    NOT BLORD_BUILD MATCHES "^(BlockmanLORD|GameServer|BlockmanEditor)$")
    set(BLORD_BUILD "BlockmanLORD")
    message(STATUS "BLORD_BUILD not set or invalid. Defaulting to BlockmanLORD.")
endif()
project(${BLORD_BUILD} VERSION 10000 LANGUAGES C CXX)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
## settings
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(POSITION_INDEPENDENT_CODE ON)
## compile flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -Wall -flto -O3")
set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -flto")
## build type
if(NOT CMAKE_BUILD_TYPE OR 
    NOT CMAKE_BUILD_TYPE MATCHES "^(Debug|Release)$")
    set(CMAKE_BUILD_TYPE Debug)
    message(STATUS "CMAKE_BUILD_TYPE not set or invalid. Defaulting to Debug.")
endif()
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(BLORD_DEBUG)
    set(CMAKE_BINARY_DIR "${CMAKE_SOURCE_DIR}/build/debug/${CMAKE_SYSTEM_NAME}")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    add_compile_definitions(BLORD_RELEASE)
    set(CMAKE_BINARY_DIR "${CMAKE_SOURCE_DIR}/build/release/${CMAKE_SYSTEM_NAME}")
endif()
if(NOT BLORD_MODEL OR 
    NOT BLORD_MODEL MATCHES "^(gl|gles|vk|d3d|m)$")
    set(BLORD_MODEL "gl")
    message(STATUS "BLORD_MODEL not set or invalid. Defaulting to gl.")
endif()
### Sources
if(BLORD_BUILD STREQUAL "BlockmanLORD")
    ## client
    file(GLOB_RECURSE CLIENT_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/client/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/client/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/client/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/client/*.h
    )
    add_executable(${PROJECT_NAME} ${CLIENT_SOURCE})
    ## 3d aka model
    include(source/get_model)
    ## icon
    set(ICON_RESOURCE "res/mipmap-xxxhdpi/app_launcher.rc")
    target_sources(${PROJECT_NAME} PRIVATE ${ICON_RESOURCE})
    target_compile_definitions(${PROJECT_NAME} PRIVATE ICON_RESOURCE=1)
    ## configs
    #if(WIN32)
    #    set(MY_APP_MANIFEST "${CMAKE_SOURCE_DIR}/res/app.manifest")
    #    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    #        COMMAND ${CMAKE_COMMAND} -E copy "${MY_APP_MANIFEST}" "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
    #    )
    #    set_target_properties(${PROJECT_NAME} PROPERTIES WIN32_EXECUTABLE TRUE)
    #endif() # fix me later
    if(UNIX AND NOT APPLE)
        configure_file("${CMAKE_SOURCE_DIR}/res/app.desktop.in" "${CMAKE_BINARY_DIR}/res/app.desktop" @ONLY)
        install(FILES "${CMAKE_BINARY_DIR}/res/app.desktop" DESTINATION "/usr/share/applications")
    endif()
    if(APPLE)
        set(MAC_APP_BUNDLE "${CMAKE_BINARY_DIR}/BlockmanLORD.app")
        file(MAKE_DIRECTORY "${MAC_APP_BUNDLE}/Contents/MacOS")
        file(MAKE_DIRECTORY "${MAC_APP_BUNDLE}/Contents/Resources")
        configure_file("${CMAKE_SOURCE_DIR}/res/Info.plist" "${MAC_APP_BUNDLE}/Contents/Info.plist" COPYONLY)
        set(MY_APP_EXECUTABLE "$<TARGET_FILE:${PROJECT_NAME}>")
        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy "${MY_APP_EXECUTABLE}" "${MAC_APP_BUNDLE}/Contents/MacOS/${PROJECT_NAME}"
        )
    endif()
    ## world
    #include(source/get_world)
    ## actor
    include(source/get_actor)
    ## lua
    include(source/get_lua)
    ## gui
    include(source/get_gui)
    ## network
    include(source/get_network)
    ## common 
    include(source/get_common)
elseif(BLORD_BUILD STREQUAL "GameServer")
    ## server
    file(GLOB_RECURSE SERVER_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/server/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/server/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/server/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/server/*.h
    )
    add_executable(${PROJECT_NAME} ${SERVER_SOURCE})
    ## boost
    include(get_boost)
    ## sol2
    include(get_sol2)
    ## lua
    include(source/get_lua)
    ## network
    include(source/get_network)
    ## common 
    include(source/get_common)
elseif(BLORD_BUILD STREQUAL "BlockmanEditor")
    ## editor
    file(GLOB_RECURSE EDITOR_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/editor/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/editor/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/editor/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/dev/editor/*.h
    )
    add_executable(${PROJECT_NAME} ${EDITOR_SOURCE})
    ## 3d aka model
    include(source/get_model)
    ## icon
    set(ICON_RESOURCE "res/mipmap-xxxhdpi/app_launcher.rc")
    target_sources(${PROJECT_NAME} PRIVATE ${ICON_RESOURCE})
    target_compile_definitions(${PROJECT_NAME} PRIVATE ICON_RESOURCE=1)
    ## world
    #include(source/get_world)
    ## actor
    include(source/get_actor)
    ## lua
    include(source/get_lua)
    ## gui
    include(source/get_gui)
    ## network
    include(source/get_network)
    ## common 
    include(source/get_common)
endif()
### Security
# by @Comical
if(CMAKE_BUILD_TYPE STREQUAL "Release" AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    add_compile_options(
        -s                      # Remove debug symbols
        -fvisibility=hidden     # Hide exported symbols
        -fdata-sections         # Remove unused data sections
        -ffunction-sections     # Remove unused function sections
        -O3                     # Maximum optimization
        -fstack-protector-strong # Protect against stack-based attacks
        -fstack-clash-protection # Protect against stack clash attacks
        -fPIE                   # Enable Position Independent Executable
        -D_FORTIFY_SOURCE=2     # Enable buffer overflow protection
        -fno-rtti               # Disable RTTI (Runtime Type Information)
        -fno-exceptions         # Disable exception handling
        -fmerge-all-constants   # Merge identical constants
        -freorder-blocks-and-partition # Reorder code blocks
        -fno-plt                # Disable PLT for indirect calls
        -mshstk                 # Enable Shadow Stack (Intel CET support)
        -fsanitize=address      # AddressSanitizer for memory corruption
        -fsanitize=undefined    # Detect undefined behavior
        -fopaque-pointers       # Opaque pointers to obfuscate memory structures
        -fmacro-prefix-map=${CMAKE_SOURCE_DIR}=. # Obfuscate source paths
        -ffile-prefix-map=${CMAKE_SOURCE_DIR}=. # Obfuscate file paths
        -march=native           # Optimize for the current CPU
        -mtune=native           # Tune for the current CPU
    )
    add_link_options(
        -Wl,--gc-sections       # Remove unused sections at linking
        -Wl,--strip-all         # Remove all symbols
        -Wl,--build-id=none     # Remove build ID from binary
        -Wl,-z,relro,-z,now     # Enable RELRO (Read-Only Relocations)
        -Wl,-z,noexecstack      # Mark stack as non-executable
        -Wl,-z,nodlopen         # Disable dynamic library loading
        -Wl,-z,defs             # Require all symbols to be defined at link-time
        -pie                    # Enable Position Independent Executable
    )
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    add_compile_options(-flto)
    add_link_options(-flto)
    find_program(STRIP_PATH strip)
    if(STRIP_PATH)
        add_custom_command(
            TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND ${STRIP_PATH} --strip-all -g -S -d --strip-debug --strip-dwo --strip-unneeded $<TARGET_FILE:${PROJECT_NAME}>
            COMMENT "Stripping binary to remove debugging symbols..."
        )
    else()
        message(WARNING "Strip not found. Skipping stripping.")
    endif()
    find_program(UPX_PATH upx)
    if(UPX_PATH)
        add_custom_command(
            TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND ${UPX_PATH} --best --lzma $<TARGET_FILE:${PROJECT_NAME}>
            COMMENT "Compressing binary with UPX..."
        )
    else()
        message(WARNING "UPX not found. Skipping UPX compression.")
    endif()
    find_program(OBFUSCATOR_PATH string-obfuscator)
    if(OBFUSCATOR_PATH)
        add_custom_command(
            TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND ${OBFUSCATOR_PATH} $<TARGET_FILE:${PROJECT_NAME}>
            COMMENT "Obfuscating static strings in binary..."
        )
    else()
        message(WARNING "String obfuscator not found. Skipping string obfuscation.")
    endif()
    add_compile_options(
        -fno-debug-info            # Remove debug info
        -fno-asynchronous-unwind-tables # Disable unwind tables
        -fno-dwarf2-cfi-asm        # Obfuscate debug information
        -fvisibility-inlines-hidden # Hide inline functions' visibility
        -frename-registers         # Randomize register names
        -fno-merge-constants       # Prevent merging identical constants
        -fno-reorder-functions     # Disable function reordering
    )
endif()
