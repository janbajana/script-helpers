#!/bin/bash

#export CC=/usr/bin/clang-7
#export CXX=/usr/bin/clang++-7

set -x

SOURCES_FOLDER="$1"
BUILD_FOLDER="$2"
BUILD_TYPE="$3" # Release/Debug
BUILD_ARCH="$4" #yocto/Win64/linux
SOURCE_PROJECT="magnum-plugins"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"

GENERATOR="Ninja"

if [ "$BUILD_ARCH" = "yocto" ] ; then
ADDITIONAL_CMAKE_PARAMS="-DCMAKE_TOOLCHAIN_FILE=/usr/local/vos-x86_64/DAQRI-VOS-Toolchain-GCC.cmake"
elif [ "$BUILD_ARCH" = "Win64" ] ; then
ADDITIONAL_CMAKE_PARAMS=""
GENERATOR="Visual Studio 15 2017 Win64"
else
ADDITIONAL_CMAKE_PARAMS=""
BUILD_ARCH="x86"
#export CC=/usr/bin/clang
#export CXX=/usr/bin/clang++
fi

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_ARCH}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-install-${BUILD_ARCH}-${BUILD_TYPE}
STAGING_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-staging-${BUILD_ARCH}-${BUILD_TYPE}

# Windows: all binaries have to be installed to the same location including Corrade.
INSTALL_LOCATION=${BUILD_FOLDER}/install
STAGING_LOCATION=${BUILD_FOLDER}/staging

mkdir -p "${BUILD_LOCATION}"
rm -rf "${BUILD_LOCATION}"/*
cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DCMAKE_STAGING_PREFIX="${STAGING_LOCATION}" \
  -DCMAKE_PREFIX_PATH="${BUILD_FOLDER}/staging;${BUILD_FOLDER}/staging/bin;E:\Git\build-win\SDL2-2.0.10" \
  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
  -DWITH_ASSIMPIMPORTER=OFF \
  ${ADDITIONAL_CMAKE_PARAMS}

#cd ${BUILD_LOCATION}
#cmake --build . --config ${BUILD_TYPE}
