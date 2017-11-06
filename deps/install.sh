# Setup

ORG_DIR=$PWD
DEPS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE_NAME=`basename "$0"`
CPU_CORES="$(grep -c ^processor /proc/cpuinfo)"
LIB_DIR="$DEPS_DIR/lib"
INC_DIR="$DEPS_DIR/include"
BUILD_DIR="$DEPS_DIR/build"
CLONE_DIR="$DEPS_DIR/clone"

function inform {
	echo "Install Log: $1"
}

function runner {
	inform "Running: $1"
	$1
	if [ $? -ne 0 ]; then
		inform "Failed to Run: $1"
		exit $?
	fi
}

function enter_dir {
	inform "Entering $1"
	runner "cd $1"
}

function cloner {
	inform "Cloning $1"
	enter_dir $CLONE_DIR
	runner "git clone $1"
}

function builder {
	inform "Making $1"
	runner "rm -rf $BUILD_DIR/*"
	enter_dir $BUILD_DIR
	runner "cmake $1 -DCMAKE_BUILD_TYPE=Release"
	runner "make -j $CPU_CORES"
}

if [ "$ORG_DIR" != "$DEPS_DIR" ]; then
	enter_dir $DEPS_DIR
fi

inform "Cleaning Directory $DEPS_DIR"
for i in $(ls); do
	if [ "$FILE_NAME" != "$i" ]; then
		runner "rm -rf $i"
	fi
done

runner "mkdir $LIB_DIR"
runner "mkdir $INC_DIR"
runner "mkdir $BUILD_DIR"
runner "mkdir $CLONE_DIR"

# Create needed bin folder
runner "rm -rf $DEPS_DIR/../bin"
runner "mkdir $DEPS_DIR/../bin"

#####################################################################

inform "Installing Google Test"
cloner "https://github.com/google/googletest.git"

GTEST_CLONE_DIR="$CLONE_DIR/googletest"
GTEST_CLONE_GTEST="$GTEST_CLONE_DIR/googletest"
GTEST_CLONE_GMOCK="$GTEST_CLONE_DIR/googlemock"

builder $GTEST_CLONE_GTEST
runner "cp $BUILD_DIR/*.a $LIB_DIR"
runner "cp -rf $GTEST_CLONE_GTEST/include/* $INC_DIR"

builder $GTEST_CLONE_GMOCK
runner "cp $BUILD_DIR/*.a $LIB_DIR"
runner "cp -rf $GTEST_CLONE_GMOCK/include/* $INC_DIR"

inform "Installing Google Benchmark"
cloner "https://github.com/google/benchmark.git"

GBENCH_CLONE_DIR="$CLONE_DIR/benchmark"

builder $GBENCH_CLONE_DIR
runner "cp $BUILD_DIR/src/*.a $LIB_DIR"
runner "cp -rf $GBENCH_CLONE_DIR/include/* $INC_DIR"


######################################################################








