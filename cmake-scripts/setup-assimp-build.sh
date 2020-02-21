#!/bin/bash

set -x

SOURCES_FOLDER="$1" # input directory (example) /e/Git
BUILD_FOLDER="$2"   # output directory (example) /e/Git/build
BUILD_TYPE="$3"     # Release/Debug
BUILD_ARCH="$4"     # Android/Win64/linux
PROCESS_BUILD="$5"  # ON/OFF build or configurtion only

SOURCE_PROJECT="assimp"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"

GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_ARCH}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}

if [ "$BUILD_ARCH" = "Android" ]; then
    BUILD_ABI="arm64-v8a" # arm64-v8a/armeabi-v7a (Android only)
    BUILD_LOCATION=${BUILD_LOCATION}-${BUILD_ABI}
fi

mkdir -p "${BUILD_LOCATION}"
rm -rf "${BUILD_LOCATION}"/*

if [ "$BUILD_ARCH" = "Android" ] ; then

  ADDITIONAL_CMAKE_PARAMS="-DCMAKE_TOOLCHAIN_FILE=/usr/local/vos-x86_64/DAQRI-VOS-Toolchain-GCC.cmake"

elif [ "$BUILD_ARCH" = "Win64" ] ; then

  ADDITIONAL_CMAKE_PARAMS=" \
    -A Win32 \
  "
  GENERATOR="Visual Studio 16 2019"

else

  ADDITIONAL_CMAKE_PARAMS=""
  BUILD_ARCH="x86"

  export CC=/usr/bin/clang
  export CXX=/usr/bin/clang++

fi

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
  -DBUILD_SHARED_LIBS=OFF \
  ${ADDITIONAL_CMAKE_PARAMS}

if [ "$PROCESS_BUILD" = "ON" ]; then
    cd ${BUILD_LOCATION}
    cmake --build . --config ${BUILD_TYPE} --target install
fi