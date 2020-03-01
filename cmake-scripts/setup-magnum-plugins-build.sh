#!/bin/bash

set -x

SOURCES_FOLDER="$1" # root input directory (example) /e/Git
BUILD_FOLDER="$2"   # build output directory (example) /e/Git/build/
BUILD_TYPE="$3"     # Release/Debug
BUILD_ARCH="$4"     # Android/Win64/linux
PROCESS_BUILD="$5"  # ON/OFF

SOURCE_PROJECT="magnum-plugins"
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

if [ "$BUILD_ARCH" = "Android" ]; then

if [[ -z "${ANDROID_NDK_HOME}" ]]; then
    echo "ANDROID_NDK_HOME environment variable not set!"
    exit 1
fi
  # ANDROID_NDK_HOME=${HOME}/AppData/Local/Android/Sdk/ndk/20.0.5594570

  ADDITIONAL_CMAKE_PARAMS=""
  
    cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -G"${GENERATOR}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
        -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake" \
        -DCMAKE_ANDROID_NDK="${ANDROID_NDK_HOME}" \
        -DCMAKE_SYSTEM_NAME=Android \
        -DCMAKE_SYSTEM_VERSION=26 \
        -DCMAKE_ANDROID_ARCH_ABI=${BUILD_ABI} \
        -DANDROID_NATIVE_API_LEVEL=26 \
        -DANDROID_ABI=${BUILD_ABI} \
        -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
        -DCMAKE_ANDROID_STL_TYPE=c++_static \
        -DCMAKE_FIND_ROOT_PATH="${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}" \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -DWITH_ASSIMPIMPORTER=OFF \
        -DWITH_TINYGLTFIMPORTER=ON \
        -DWITH_STBIMAGEIMPORTER=ON \
        -DWITH_JPEGIMPORTER=OFF \
        -DWITH_PNGIMPORTER=OFF

elif [ "$BUILD_ARCH" = "Win64" ]; then

  GENERATOR="Visual Studio 16 2019"
  ADDITIONAL_CMAKE_PARAMS=""

  ADDITIONAL_CMAKE_PARAMS=" \
      -DBUILD_PLUGINS_STATIC=OFF
  "

elif [ "$BUILD_ARCH" = "Linux" ]; then

  export CC=/usr/bin/clang
  export CXX=/usr/bin/clang++

  ADDITIONAL_CMAKE_PARAMS=" \
      -DBUILD_PLUGINS_STATIC=OFF
  "

fi

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
    -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
    -DWITH_ASSIMPIMPORTER=OFF \
    -DWITH_TINYGLTFIMPORTER=ON \
    -DWITH_STBIMAGEIMPORTER=ON \
    -DWITH_JPEGIMPORTER=OFF \
    -DWITH_PNGIMPORTER=OFF \
    -DBUILD_STATIC=ON \
    ${ADDITIONAL_CMAKE_PARAMS}

if [ "$PROCESS_BUILD" = "ON" ]; then
    cd ${BUILD_LOCATION}
    cmake --build . --config ${BUILD_TYPE} --target install
fi