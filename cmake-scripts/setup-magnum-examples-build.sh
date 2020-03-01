#!/bin/bash

set -x

SOURCES_FOLDER="$1" # input directory (example) /e/Git/
BUILD_FOLDER="$2"   # output directory (example) /e/Git/build
BUILD_TYPE="$3"     # Release/Debug
BUILD_ARCH="$4"     # Android/Win64/linux
PROCESS_BUILD="$5"  # ON/OFF

SOURCE_PROJECT="magnum-examples"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"
GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_ARCH}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}

mkdir -p "${BUILD_LOCATION}"
rm -rf "${BUILD_LOCATION}"/*

if [ "$BUILD_ARCH" = "Android" ] ; then

ANDROID_NDK=${HOME}/AppData/Local/Android/Sdk/ndk/20.0.5594570

ADDITIONAL_CMAKE_PARAMS=" \
    -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
    -DCMAKE_ANDROID_NDK=${ANDROID_NDK} \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=22 \
    -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a \
    -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
    -DCMAKE_ANDROID_STL_TYPE=c++_static \
    -DCORRADE_RC_EXECUTABLE=${BUILD_FOLDER}/install-Win64-Release/bin/corrade-rc.exe \
    "

elif [ "$BUILD_ARCH" = "Win64" ] ; then

GENERATOR="Visual Studio 16 2019"

ADDITIONAL_CMAKE_PARAMS=""

elif [ "$BUILD_ARCH" = "macOS" ]; then

  ADDITIONAL_CMAKE_PARAMS=""

else

  ADDITIONAL_CMAKE_PARAMS=""
  BUILD_ARCH="x86"
  export CC=/usr/bin/clang
  export CXX=/usr/bin/clang++

fi

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DIMGUI_DIR="${SOURCES_FOLDER}/imgui" \
  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
  -DWITH_IMGUI_EXAMPLE=ON \
  -DWITH_MOTIONBLUR_EXAMPLE=ON \
  -DWITH_MOUSEINTERACTION_EXAMPLE=ON \
  -DWITH_PICKING_EXAMPLE=ON \
  -DWITH_PRIMITIVES_EXAMPLE=ON \
  -DWITH_SHADOWS_EXAMPLE=ON \
  -DWITH_VIEWER_EXAMPLE=ON \
  ${ADDITIONAL_CMAKE_PARAMS}

if [ "$PROCESS_BUILD" = "ON" ]; then
    cd ${BUILD_LOCATION}
    cmake --build . --config ${BUILD_TYPE} --target install
fi