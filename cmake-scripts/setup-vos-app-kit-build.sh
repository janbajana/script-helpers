#!/bin/bash

set -x

SOURCES_FOLDER="$1" # home directory (example) /e/Git/
BUILD_FOLDER="$2"   # output directory (example) /e/Git/build/
BUILD_TYPE="$3"     # Release/Debug
BUILD_SYSTEM="$4"   # Android/Win64/linux
BUILD_ARCH=arm64-v8a     # arm64-v8a/armeabi-v7a (Android only)
SOURCE_PROJECT="vos-app-kit"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"
GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_SYSTEM}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/install-${BUILD_SYSTEM}-${BUILD_TYPE}
THIRDPARTY_INSTALL_LOCATION=${BUILD_FOLDER}/thirdparty-${BUILD_SYSTEM}-${BUILD_TYPE}

if [ "$BUILD_SYSTEM" = "Android" ]; then
    BUILD_LOCATION=${BUILD_LOCATION}-${BUILD_ARCH}
fi

mkdir -p "${BUILD_LOCATION}"
rm -rf "${BUILD_LOCATION}"/*

if [ "$BUILD_SYSTEM" = "Android" ]; then

    if [[ -z "${ANDROID_NDK_HOME}" ]]; then
        echo "ANDROID_NDK_HOME environment variable not set!"
        exit 1
    fi

    if [[ -z "${SXR_HOME}" ]]; then
        echo "SXR_HOME environment variable not set!"
        exit 1
    fi

    cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -G"${GENERATOR}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
        -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake" \
        -DCMAKE_ANDROID_NDK="${ANDROID_NDK_HOME}" \
        -DCMAKE_SYSTEM_NAME=Android \
        -DCMAKE_SYSTEM_VERSION=28 \
        -DCMAKE_ANDROID_ARCH_ABI=${BUILD_ARCH} \
        -DANDROID_ABI=${BUILD_ARCH} \
        -DANDROID_NATIVE_API_LEVEL=28 \
        -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
        -DCMAKE_ANDROID_STL_TYPE=c++_static \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -D3RDPARTY_INSTALL_PREFIX="${THIRDPARTY_INSTALL_LOCATION}" \
        -DVOSVisionCore_DIR="${BUILD_FOLDER}/vos-vision-build-${BUILD_SYSTEM}-${BUILD_TYPE}-${BUILD_ARCH}/cmake" \
        -DVOSPlatformGraphics_DIR="${BUILD_FOLDER}/vos-graphics-build-${BUILD_SYSTEM}-${BUILD_TYPE}-${BUILD_ARCH}/cmake" \
        -DVOSPlatformCalibration_DIR="${BUILD_FOLDER}/vos-calibration-build-${BUILD_SYSTEM}-${BUILD_TYPE}-${BUILD_ARCH}/cmake" \
        -DVOSPlatformRuntime_DIR="${BUILD_FOLDER}/vos-runtime-build-${BUILD_SYSTEM}-${BUILD_TYPE}-${BUILD_ARCH}/cmake" \
        -DENABLE_LEGACY_RUNTIME=OFF \
        -DENABLE_ANDROID_RUNTIME=ON \
        -DSXR_HOME="${SXR_HOME}"

elif [ "$BUILD_SYSTEM" = "Win64" ]; then

    GENERATOR="Visual Studio 16 2019"

    cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -G"${GENERATOR}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -D3RDPARTY_INSTALL_PREFIX="${THIRDPARTY_INSTALL_LOCATION}" \
        -DVOSVisionCore_DIR="${BUILD_FOLDER}/vos-vision-build-${BUILD_SYSTEM}-${BUILD_TYPE}/cmake" \
        -DVOSPlatformGraphics_DIR="${BUILD_FOLDER}/vos-graphics-build-${BUILD_SYSTEM}-${BUILD_TYPE}/cmake" \
        -DVOSPlatformCalibration_DIR="${BUILD_FOLDER}/vos-calibration-build-${BUILD_SYSTEM}-${BUILD_TYPE}/cmake" \
        -DVOSPlatformRuntime_DIR="${BUILD_FOLDER}/vos-runtime-build-${BUILD_SYSTEM}-${BUILD_TYPE}/cmake"

else #expected Linux x86

    BUILD_SYSTEM="x86"

    export CC=/usr/bin/clang
    export CXX=/usr/bin/clang++

    cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -G"${GENERATOR}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -D3RDPARTY_INSTALL_PREFIX="${THIRDPARTY_INSTALL_LOCATION}" \
        -DVOSVisionCore_DIR="${BUILD_FOLDER}/vos-vision-build-${BUILD_SYSTEM}-${BUILD_TYPE}/cmake" \
        -DVOSPlatformGraphics_DIR="${BUILD_FOLDER}/vos-graphics-build-${BUILD_SYSTEM}-${BUILD_TYPE}/cmake" \
        -DVOSPlatformCalibration_DIR="${BUILD_FOLDER}/vos-calibration-build-${BUILD_SYSTEM}-${BUILD_TYPE}/cmake" \
        -DVOSPlatformRuntime_DIR="${BUILD_FOLDER}/vos-runtime-build-${BUILD_SYSTEM}-${BUILD_TYPE}/cmake"

fi

#cd ${BUILD_LOCATION}
#cmake --build . --config ${BUILD_TYPE}
#cmake --build . --target install --config ${BUILD_TYPE}
