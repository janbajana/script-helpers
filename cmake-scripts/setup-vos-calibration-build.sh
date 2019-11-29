#!/bin/bash

set -x

SOURCES_FOLDER="$1" # input directory (example) /e/Git/
BUILD_FOLDER="$2"   # output directory (example) /e/Git/build/
BUILD_TYPE="$3"     # Release/Debug
BUILD_ARCH="$4"     # Android/Win64/linux
SOURCE_PROJECT="vos-calibration"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"
GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_ARCH}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}
THIRDPARTY_INSTALL_LOCATION=${BUILD_FOLDER}/thirdparty-${BUILD_ARCH}-${BUILD_TYPE}

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
    
    cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -G"${GENERATOR}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
        -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake" \
        -DCMAKE_ANDROID_NDK="${ANDROID_NDK_HOME}" \
        -DCMAKE_SYSTEM_NAME=Android \
        -DCMAKE_SYSTEM_VERSION=28 \
        -DCMAKE_ANDROID_ARCH_ABI=${BUILD_ABI} \
        -DANDROID_ABI=${BUILD_ABI} \
        -DANDROID_NATIVE_API_LEVEL=28 \
        -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
        -DCMAKE_ANDROID_STL_TYPE=c++_static \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -D3RDPARTY_INSTALL_PREFIX="${THIRDPARTY_INSTALL_LOCATION}" \
        -DVOSVisionCore_DIR="${BUILD_FOLDER}/vos-vision-build-${BUILD_ARCH}-${BUILD_TYPE}-${BUILD_ABI}/cmake" \
        -DVOSVisionCoreCpp_DIR="${BUILD_FOLDER}/vos-vision-build-${BUILD_ARCH}-${BUILD_TYPE}-${BUILD_ABI}/"

elif [ "$BUILD_ARCH" = "Win64" ]; then

    GENERATOR="Visual Studio 16 2019"

    cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -G"${GENERATOR}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -D3RDPARTY_INSTALL_PREFIX="${THIRDPARTY_INSTALL_LOCATION}" \
        -DVOSVisionCore_DIR="${BUILD_FOLDER}/vos-vision-build-${BUILD_ARCH}-${BUILD_TYPE}/cmake" \
        -DVOSVisionCoreCpp_DIR="${BUILD_FOLDER}/vos-vision-build-${BUILD_ARCH}-${BUILD_TYPE}/"

else #expected Linux x86

    BUILD_ARCH="x86"

    export CC=/usr/bin/clang
    export CXX=/usr/bin/clang++

    cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -G"${GENERATOR}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -D3RDPARTY_INSTALL_PREFIX="${THIRDPARTY_INSTALL_LOCATION}" \
        -DVOSVisionCore_DIR="${BUILD_FOLDER}/vos-vision-build-${BUILD_ARCH}-${BUILD_TYPE}/cmake" \
        -DVOSVisionCoreCpp_DIR="${BUILD_FOLDER}/vos-vision-build-${BUILD_ARCH}-${BUILD_TYPE}/"

fi

#cd ${BUILD_LOCATION}
#cmake --build . --config ${BUILD_TYPE}
#cmake --build . --target install --config ${BUILD_TYPE}
