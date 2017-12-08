#!/bin/bash

BUILD_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_DIR="$BUILD_DIR/.."
APPS_DIR="$ROOT_DIR/apps"
DEPS_DIR="$ROOT_DIR/deps"
BIN_DIR="$ROOT_DIR/bin"
SRC_DIR="$ROOT_DIR/src"
OBJ_DIR="$BIN_DIR/obj"

COMPILER="g++"
STD="-std=c++11"
FLAGS="-O3 -Wall -Werror -pedantic"

# Setup

rm -rf "$OBJ_DIR"
mkdir "$OBJ_DIR"

# compile(.cpp_dir, output_file, extra)
function compile()
{
    echo -e "\n$1 output to $BIN_DIR/$2 with: $3\n"
    $COMPILER $STD $FLAGS $(find "$OBJ_DIR" | grep ".o$") $(find $1 | grep .cpp) -o $2 -I $SRC_DIR $3
}

# Build Library

cd "$OBJ_DIR"
$COMPILER $STD $FLAGS $(find $SRC_DIR | grep .cpp) -c

# Build Benchmark

GBENCH_LIB="-lbenchmark -lpthread"

#$COMPILER $STD $FLAGS $(find "$APPS_DIR/bencher" | grep .cpp) -o "$BIN_DIR/bencher" -I "$DEPS_DIR/include" -I "$SRC_DIR" -L "$DEPS_DIR/lib" $GBENCH_LIB
compile "$APPS_DIR/bencher" "$BIN_DIR/bencher" "-I $DEPS_DIR/include -L $DEPS_DIR/lib $GBENCH_LIB"

# Build Tests

GTEST_LIB="-lgtest -lgtest_main -lgmock -lgmock_main -lpthread"

#$COMPILER $STD $FLAGS $(find "$APPS_DIR/tester" | grep .cpp) -o "$BIN_DIR/tester" -I "$DEPS_DIR/include" -I "$SRC_DIR" -L "$DEPS_DIR/lib" $GTEST_LIB
compile "$APPS_DIR/tester" "$BIN_DIR/tester" "-I $DEPS_DIR/include -L $DEPS_DIR/lib $GTEST_LIB"

# Compiler

#$COMPILER $STD $FLAGS $(find "$APPS_DIR/compiler" | grep .cpp) $(find . | grep .o) -o "$BIN_DIR/compiler" -I "$SRC_DIR"
compile "$APPS_DIR/compiler" "$BIN_DIR/compiler" ""
