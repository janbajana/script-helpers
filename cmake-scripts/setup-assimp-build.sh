#!/bin/bash

#export CC=/usr/bin/clang-7
#export CXX=/usr/bin/clang++-7

set -x

SOURCES_FOLDER="$1"
BUILD_FOLDER="$2"
BUILD_TYPE="$3" # Release/Debug
BUILD_ARCH="$4" #yocto/Win64/linux
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

  ADDITIONAL_CMAKE_PARAMS=""
  GENERATOR="Visual Studio 16 2019"

else

  ADDITIONAL_CMAKE_PARAMS=""
  BUILD_ARCH="x86"
  #export CC=/usr/bin/clang
  #export CXX=/usr/bin/clang++
fi

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -A Win32 \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DCMAKE_STAGING_PREFIX="${STAGING_LOCATION}" \
  -DCMAKE_PREFIX_PATH="" \
  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
  ${ADDITIONAL_CMAKE_PARAMS}

#cd ${BUILD_LOCATION}
#cmake --build . --config ${BUILD_TYPE}
