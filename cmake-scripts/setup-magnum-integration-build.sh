#!/bin/bash

set -x

SOURCES_FOLDER="$1" # input directory (example) /e/Git
BUILD_FOLDER="$2"   # output directory (example) /e/Git/build/
BUILD_TYPE="$3"     # Release/Debug
BUILD_ARCH="$4"     # Android/Win64/linux
PROCESS_BUILD="$5"  # ON/OFF

SOURCE_PROJECT="magnum-integration"
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

ANDROID_NDK=${HOME}/AppData/Local/Android/Sdk/ndk/20.0.5594570
# INSTALL_LOCATION=${ANDROID_NDK}/platforms/android-22/arch-arm64/usr

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
  -DCMAKE_ANDROID_NDK=${ANDROID_NDK} \
  -DCMAKE_SYSTEM_NAME=Android \
  -DCMAKE_SYSTEM_VERSION=26 \
  -DCMAKE_ANDROID_ARCH_ABI=${BUILD_ABI} \
  -DANDROID_NATIVE_API_LEVEL=26 \
  -DANDROID_ABI=${BUILD_ABI} \
  -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
  -DCMAKE_ANDROID_STL_TYPE=c++_static \
  -DCORRADE_RC_EXECUTABLE="/c/Corrade/bin/corrade-rc.exe" \
  -DCMAKE_FIND_ROOT_PATH="${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
  -DIMGUI_DIR="${SOURCES_FOLDER}/imgui" \
  -DWITH_IMGUI=ON 

#  -D_CORRADE_MODULE_DIR="${ANDROID_NDK}/sysroot/usr/share/cmake/Corrade" \
#  -DMAGNUM_INCLUDE_INSTALL_PREFIX="${ANDROID_NDK}/sysroot/usr" \

elif [ "$BUILD_ARCH" = "Win64" ] ; then

GENERATOR="Visual Studio 16 2019"

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DIMGUI_DIR="${SOURCES_FOLDER}/imgui" \
  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
  -DWITH_IMGUI=ON

else

ADDITIONAL_CMAKE_PARAMS=""
BUILD_ARCH="x86"
#export CC=/usr/bin/clang
#export CXX=/usr/bin/clang++

fi

if [ "$PROCESS_BUILD" = "ON" ]; then
    cd ${BUILD_LOCATION}
    cmake --build . --config ${BUILD_TYPE} --target install
fi