cmake_minimum_required(VERSION 3.8)

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

# Library setup
include_directories(${DEPS_INC_DIR})
link_directories(${DEPS_LIB_DIR})

# Binary output
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

# Build
if (${BUILD_BENCHER})
    find_package(Threads)
    add_executable(bencher ${BENCHER_SRCS})
    target_link_libraries(bencher
            benchmark
            ${CMAKE_THREAD_LIBS_INIT})
endif ()

if (${BUILD_TESTER})
    find_package(Threads)
    add_executable(tester ${TESTER_SRCS})
    target_link_libraries(tester
            gtest gtest_main
            gmock gmock_main
            ${CMAKE_THREAD_LIBS_INIT})
endif ()

if (${BUILD_COMPILER})
    add_executable(compiler ${COMPILER_SRCS})
endif()