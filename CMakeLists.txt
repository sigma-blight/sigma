cmake_minimum_required(VERSION 3.0)

# Apps
project(bencher)
project(tester)
project(compiler)

option(BUILD_BENCHER "BUILD_BENCHER" ON)
option(BUILD_TESTER "BUILD_TESTER" ON)
option(BUILD_COMPILER "BUILD_COMPILER" ON)

# C++ setup
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
    -O3                                 \
    -Wall                               \
    -pedantic                           \
    -fno-rtti")


# Source
set(APPS_DIR "${CMAKE_SOURCE_DIR}/apps")
set(DEPS_DIR "${CMAKE_SOURCE_DIR}/deps")
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")

set(DEPS_INC_DIR "${DEPS_DIR}/include")
set(DEPS_LIB_DIR "${DEPS_DIR}/lib")

set(BENCHER_SRC_DIR "${APPS_DIR}/bencher")
set(TESTER_SRC_DIR "${APPS_DIR}/tester")
set(COMPILER_SRC_DIR "${APPS_DIR}/compiler")

file(GLOB BENCHER_SRCS "${BENCHER_SRC_DIR}/*.cpp")
file(GLOB TESTER_SRCS "${TESTER_SRC_DIR}/*.cpp")
file(GLOB COMPILER_SRCS "${COMPILER_SRC_DIR}/*.cpp")
file(GLOB_RECURSE LIBRARY_SRCS "${SRC_DIR}/*.cpp")

# Library setup
include_directories(${DEPS_INC_DIR})
link_directories(${DEPS_LIB_DIR})

# Binary output
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

# Create library
if ("${LIBRARY_SRCS}" STREQUAL "")
    message("Library contains no source files")
	set(LIBRARY_BUILT false)
else()
    message("Building library")
    add_library(library STATIC ${LIBRARY_SRCS})
	set(LIBRARY_BUILT true)
endif()

function(link_library target)
	if ($LIBRARY_BUILT)
		target_link_libraries($target library)
	endif()
endfunction()

# Build
if (${BUILD_BENCHER})
    if ("${BENCHER_SRCS}" STREQUAL "")
        message("Bencher contains no source files")
    else()
        message("Building bencher")
        find_package(Threads)
        add_executable(bencher ${BENCHER_SRCS})
        target_link_libraries(bencher
                benchmark
                ${CMAKE_THREAD_LIBS_INIT})
		link_library(bencher)
    endif()
endif ()

if (${BUILD_TESTER})
    if ("${TESTER_SRCS}" STREQUAL "")
        message("Tester contains no source files")
    else()
        message("Building tester")
        find_package(Threads)
        add_executable(tester ${TESTER_SRCS})
        target_link_libraries(tester
                gtest gtest_main
                gmock gmock_main
                ${CMAKE_THREAD_LIBS_INIT})
		link_library(tester)
    endif()
endif ()

if (${BUILD_COMPILER})
    if ("${COMPILER_SRCS}" STREQUAL "")
        message("Compiler contains no source files")
    else()
        message("Building compiler")
        add_executable(compiler ${COMPILER_SRCS})
		link_library(compiler)
    endif()
endif()
