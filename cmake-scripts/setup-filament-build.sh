#!/bin/bash

set -x

SOURCES_FOLDER="$1" # input directory (example) /e/Git/
BUILD_FOLDER="$2"   # output directory (example) /e/Git/build/
BUILD_TYPE="$3"     # Release/Debug
BUILD_ARCH="$4"     # Android/Win64/linux
SOURCE_PROJECT="filament"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"
GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_ARCH}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-install-${BUILD_ARCH}-${BUILD_TYPE}

mkdir -p "${BUILD_LOCATION}"
rm -rf "${BUILD_LOCATION}"/*

if [ "$BUILD_ARCH" = "Android" ]; then

    ANDROID_NDK=${HOME}/AppData/Local/Android/Sdk/ndk/20.0.5594570
    FILAMENT_TOOLCHAIN_FILE=${SOURCE_LOCATION}/build/toolchain-aarch64-linux-android.cmake

    cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -G"${GENERATOR}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
        -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
        -DCMAKE_ANDROID_NDK="${ANDROID_NDK}" \
        -DCMAKE_SYSTEM_NAME=Android \
        -DCMAKE_SYSTEM_VERSION=26 \
        -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a \
        -DANDROID_ABI=arm64-v8a \
        -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
        -DCMAKE_ANDROID_STL_TYPE=c++_static \
        -DENABLE_JAVA=OFF

# -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \

elif [ "$BUILD_ARCH" = "Win64" ]; then

    GENERATOR="Visual Studio 16 2019"

    cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -G"${GENERATOR}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
        -DENABLE_JAVA=OFF

else #expected Linux x86

    BUILD_ARCH="x86"
#export CC=/usr/bin/clang
#export CXX=/usr/bin/clang++

fi

#cd ${BUILD_LOCATION}
#cmake --build . --config ${BUILD_TYPE}
#cmake --build . --target install --config ${BUILD_TYPE}
