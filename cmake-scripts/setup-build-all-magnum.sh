#!/bin/bash

set -x

# This script will clean, configure and rebuild all projects. 
# Use only if you need rebuild all projects from clean because this takes time.

SOURCES_FOLDER="$1"   # input directory (example) /e/Git
BUILD_FOLDER="$2"     # output directory (example) /e/Git/build
BUILD_TYPE="$3"       # Release/Debug
BUILD_SYSTEM="$4"     # Android/Win64/macOS/Linux
BUILD_THIRD_PARTY="$5"# Build third party resources
BUILD_ABI="arm64-v8a" # arm64-v8a/armeabi-v7a (Android only)

CURRENT_LOCATION="$PWD"

# #3rd dependency
# SOURCE_PROJECT="SDL"
# cd ${CURRENT_LOCATION}
# ./setup-${SOURCE_PROJECT}-build.sh ${SOURCES_FOLDER} ${BUILD_FOLDER} ${BUILD_TYPE} ${BUILD_SYSTEM} ON

# SOURCE_PROJECT="assimp"
# cd ${CURRENT_LOCATION}
# ./setup-${SOURCE_PROJECT}-build.sh ${SOURCES_FOLDER} ${BUILD_FOLDER} ${BUILD_TYPE} ${BUILD_SYSTEM} ON

# ...
SOURCE_PROJECT="corrade"
cd ${CURRENT_LOCATION}
./setup-${SOURCE_PROJECT}-build.sh ${SOURCES_FOLDER} ${BUILD_FOLDER} ${BUILD_TYPE} ${BUILD_SYSTEM} ON

# ...
SOURCE_PROJECT="magnum"
cd ${CURRENT_LOCATION}
./setup-${SOURCE_PROJECT}-build.sh ${SOURCES_FOLDER} ${BUILD_FOLDER} ${BUILD_TYPE} ${BUILD_SYSTEM} ON

# ...
SOURCE_PROJECT="magnum-integration"
cd ${CURRENT_LOCATION}
./setup-${SOURCE_PROJECT}-build.sh ${SOURCES_FOLDER} ${BUILD_FOLDER} ${BUILD_TYPE} ${BUILD_SYSTEM} ON

# ...
SOURCE_PROJECT="magnum-plugins"
cd ${CURRENT_LOCATION}
./setup-${SOURCE_PROJECT}-build.sh ${SOURCES_FOLDER} ${BUILD_FOLDER} ${BUILD_TYPE} ${BUILD_SYSTEM} ON

# ...
SOURCE_PROJECT="magnum-examples"
cd ${CURRENT_LOCATION}
./setup-${SOURCE_PROJECT}-build.sh ${SOURCES_FOLDER} ${BUILD_FOLDER} ${BUILD_TYPE} ${BUILD_SYSTEM} ON

# ...
SOURCE_PROJECT="magnum-extras"
cd ${CURRENT_LOCATION}
./setup-${SOURCE_PROJECT}-build.sh ${SOURCES_FOLDER} ${BUILD_FOLDER} ${BUILD_TYPE} ${BUILD_SYSTEM} ON