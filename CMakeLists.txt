##############################################################
#                                                            #
# Made by Comical                                            #
# BlockmanLORD of Blockman Launcher CMake                    #
#                                                            #
##############################################################
### CMake
cmake_minimum_required(VERSION 3.30)
project(blord VERSION 10000 LANGUAGES C CXX)
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
### Platforms
## setting if null
if(NOT CMAKE_BUILD_PLATFORM OR 
    NOT CMAKE_BUILD_PLATFORM MATCHES "^(Android|iOS|macOS|Windows|Linux|HarmonyOS|Unix)$")
    set(CMAKE_BUILD_PLATFORM Linux)
    message(STATUS "CMAKE_BUILD_PLATFORM not set or invalid. Defaulting to Linux.")
endif()
## build for
if(CMAKE_BUILD_PLATFORM STREQUAL "Android")
    set(CMAKE_SYSTEM_NAME Android)
    set(CMAKE_SYSTEM_VERSION 23) 
    set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)
    set(CMAKE_ANDROID_NDK ${ANDROID_NDK})
    set(CMAKE_ANDROID_STL_TYPE c++_static)
    set(CMAKE_CXX_COMPILER clang++)
    set(CMAKE_SHARED_LIBRARY_SUFFIX ".so")
    message(STATUS "Building for Android with Clang.")
elseif(CMAKE_BUILD_PLATFORM STREQUAL "iOS")
    set(CMAKE_SYSTEM_NAME iOS)
    set(CMAKE_OSX_DEPLOYMENT_TARGET 11.0)
    set(CMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH YES)
    set(CMAKE_CXX_COMPILER clang++)
    message(STATUS "Building for iOS with Clang.")
elseif(CMAKE_BUILD_PLATFORM STREQUAL "HarmonyOS")
    set(CMAKE_SYSTEM_NAME HarmonyOS)
    set(CMAKE_CXX_COMPILER clang++)
    set(CMAKE_SHARED_LIBRARY_SUFFIX ".so")
    message(STATUS "Building for HarmonyOS with Clang.")
# not needed anymore, by @Comical
#elseif(CMAKE_BUILD_PLATFORM STREQUAL "Unix")
#    set(CMAKE_CXX_COMPILER gcc)
#    message(STATUS "Building for Unix with GCC.")
#elseif(CMAKE_BUILD_PLATFORM STREQUAL "Linux")
    #find_program(GXX_EXECUTABLE NAMES g++ PATHS /usr/bin /usr/local/bin)
    #if(GXX_EXECUTABLE)
    #    set(CMAKE_CXX_COMPILER ${GXX_EXECUTABLE})
    #    set(CMAKE_C_COMPILER /usr/bin/gcc)
    #    message(STATUS "Building for Linux with GCC: ${CMAKE_CXX_COMPILER}")
    #else()
    #    message(FATAL_ERROR "g++ compiler not found")
    #endif()
elseif(CMAKE_BUILD_PLATFORM STREQUAL "Windows")
    # not needed
    #set(CMAKE_CXX_COMPILER gcc)
    set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)
    set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
    set(CMAKE_EXECUTABLE_SUFFIX ".exe")
    message(STATUS "Building for Windows with GCC.")
elseif(CMAKE_BUILD_PLATFORM STREQUAL "macOS")
    set(CMAKE_CXX_COMPILER clang++)
    set(CMAKE_OSX_DEPLOYMENT_TARGET 10.15)
    message(STATUS "Building for macOS with Clang.")
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
set(MODEL_ROOT "${CMAKE_SOURCE_DIR}/source/model")
add_subdirectory(${MODEL_ROOT} ${CMAKE_BINARY_DIR}/blord_model_build)
include_directories(${MODEL_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_model)
## world
set(WORLD_ROOT "${CMAKE_SOURCE_DIR}/source/world")
add_subdirectory(${WORLD_ROOT} ${CMAKE_BINARY_DIR}/blord_world_build)
include_directories(${WORLD_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_world)
## actor
set(ACTOR_ROOT "${CMAKE_SOURCE_DIR}/source/actor")
add_subdirectory(${ACTOR_ROOT} ${CMAKE_BINARY_DIR}/blord_actor_build)
include_directories(${ACTOR_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_actor)
## lua
set(LUA_ROOT "${CMAKE_SOURCE_DIR}/source/lua")
add_subdirectory(${LUA_ROOT} ${CMAKE_BINARY_DIR}/blord_lua_build)
include_directories(${LUA_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_lua)
## gui
set(GUI_ROOT "${CMAKE_SOURCE_DIR}/source/gui")
add_subdirectory(${GUI_ROOT} ${CMAKE_BINARY_DIR}/blord_gui_build)
include_directories(${GUI_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_gui)
## network
set(NETWORK_ROOT "${CMAKE_SOURCE_DIR}/source/network")
add_subdirectory(${NETWORK_ROOT} ${CMAKE_BINARY_DIR}/blord_network_build)
include_directories(${NETWORK_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE blord_network)
### Library
## zlib
set(ZLIB_ROOT "${CMAKE_SOURCE_DIR}/libs/zlib")
add_subdirectory(${ZLIB_ROOT} ${CMAKE_BINARY_DIR}/zlib_build)
include_directories(${ZLIB_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE zlib)
## boost
set(BOOST_ROOT "${CMAKE_SOURCE_DIR}/libs/boost")
set(BOOST_BUILD_DIR "${CMAKE_BINARY_DIR}/boost_build")
include_directories(${BOOST_ROOT}/boost)
if(NOT EXISTS "${BOOST_BUILD_DIR}/lib")
    add_custom_target(boost_build ALL
        COMMAND ${BOOST_ROOT}/bootstrap.sh --prefix=${BOOST_BUILD_DIR}
        COMMAND ${BOOST_ROOT}/b2 headers
        COMMAND ${BOOST_ROOT}/b2 --build-dir=${BOOST_BUILD_DIR} --prefix=${BOOST_BUILD_DIR} 
            --with-regex --with-filesystem --with-system link=static threading=multi runtime-link=static install
        WORKING_DIRECTORY ${BOOST_ROOT}
    )
else()
    message(STATUS "Boost is already built. Skipping build step.")
    add_custom_target(boost_build ALL
        COMMAND ${CMAKE_COMMAND} -E echo "Boost is already built."
    )
endif()
file(GLOB BOOST_LIBS "${BOOST_BUILD_DIR}/lib/*.a" "${BOOST_BUILD_DIR}/lib/*.lib")
target_link_libraries(${PROJECT_NAME} PRIVATE ${BOOST_LIBS})
### GameServer
## source
file(GLOB_RECURSE GAMESERVER_SOURCE
    ${CMAKE_CURRENT_SOURCE_DIR}/source/server/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/source/server/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/source/server/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/source/server/*.h
)
add_executable(GameServer ${GAMESERVER_SOURCE})
## boost
target_link_libraries(GameServer PRIVATE ${BOOST_LIBS})
include_directories(GameServer PRIVATE ${BOOST_ROOT}/boost)
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