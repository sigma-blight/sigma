execute() {
    echo "$1"
    $1
    if [ $? -ne 0 ]; then
        printf "\n** FAILED **\n"
        exit $?
    fi
}

INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
UTIL_SCRIPTS_DIR="$INSTALL_DIR/.tmp.util_scripts"
UTIL_SCRIPTS_REPO="https://github.com/sigma-blight/utility_scripts.git"
INSTALL_GOOGLE_SCRIPT_DIR="$UTIL_SCRIPTS_DIR/utility_scripts/install"
SRC_DIR="$INSTALL_DIR/src"
LIB_DIR="$INSTALL_DIR/lib"
INC_DIR="$INSTALL_DIR/include"

# Directory Setup
execute "rm -rf $UTIL_SCRIPTS_DIR"
execute "mkdir $UTIL_SCRIPTS_DIR"
execute "mkdir $SRC_DIR"
execute "mkdir $LIB_DIR"
execute "mkdir $INC_DIR"

# Build Google Framework
execute "cd $UTIL_SCRIPTS_DIR"
execute "git clone $UTIL_SCRIPTS_REPO"
execute "$INSTALL_GOOGLE_SCRIPT_DIR/./google_framework.sh $SRC_DIR"

# Copy Libs and Headers
execute "cp -rf $SRC_DIR/gtest_lib/* $LIB_DIR/"
execute "cp -rf $SRC_DIR/gbench_lib/* $LIB_DIR/"
execute "cp -rf $SRC_DIR/gtest_include/* $INC_DIR/"
execute "cp -rf $SRC_DIR/gbench_include/* $INC_DIR/"

# Cleanup
execute "rm -rf $UTIL_SCRIPTS_DIR"
