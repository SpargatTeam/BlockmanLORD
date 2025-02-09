##############################################################
#                                                            #
# Made by Comical                                            #
# BlockmanLORD of Blockman Launcher CMake                    #
#                                                            #
##############################################################
### CMake
cmake_minimum_required(VERSION 3.30)
project(blord VERSION 10000 LANGUAGES C CXX)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
## settings
set(CMAKE_CXX_STANDARD 23)
# is this really needed? from @Comical
#target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)
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
### Sources
## client
file(GLOB_RECURSE CLIENT_SOURCE
    ${CMAKE_CURRENT_SOURCE_DIR}/source/client/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/source/client/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/source/client/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/source/client/*.h
)
add_executable(${PROJECT_NAME} ${CLIENT_SOURCE})
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