##############################################################
#
# Made by Comical
# BlockmanLORD of Blockman Launcher CMake
#
##############################################################
set(BOOST_ROOT "${CMAKE_SOURCE_DIR}/libs/boost")
set(BOOST_BUILD_DIR "${CMAKE_BINARY_DIR}/boost_build")
include_directories(${BOOST_ROOT})
if(NOT EXISTS "${BOOST_BUILD_DIR}/lib")
    if(WIN32)
        add_custom_target(boost_build ALL
            COMMAND ${BOOST_ROOT}/bootstrap.bat
            COMMAND ${BOOST_ROOT}/b2 headers
            COMMAND ${BOOST_ROOT}/b2 --build-dir=${BOOST_BUILD_DIR} --prefix=${BOOST_BUILD_DIR}
                --with-regex --with-filesystem --with-system link=static threading=multi runtime-link=static install
            WORKING_DIRECTORY ${BOOST_ROOT}
        )
    else()
        add_custom_target(boost_build ALL
            COMMAND ${BOOST_ROOT}/bootstrap.sh --prefix=${BOOST_BUILD_DIR}
            COMMAND ${BOOST_ROOT}/b2 headers
            COMMAND ${BOOST_ROOT}/b2 --build-dir=${BOOST_BUILD_DIR} --prefix=${BOOST_BUILD_DIR} 
                --with-regex --with-filesystem --with-system link=static threading=multi runtime-link=static install
            WORKING_DIRECTORY ${BOOST_ROOT}
        )
    endif()
else()
    message(STATUS "Boost is already built. Skipping build step.")
    add_custom_target(boost_build ALL
        COMMAND ${CMAKE_COMMAND} -E echo "Boost is already built."
    )
endif()
file(GLOB BOOST_LIBS "${BOOST_BUILD_DIR}/lib/*.a" "${BOOST_BUILD_DIR}/lib/*.lib")
target_link_libraries(${PROJECT_NAME} PRIVATE ${BOOST_LIBS})