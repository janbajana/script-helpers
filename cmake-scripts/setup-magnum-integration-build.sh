#!/bin/bash

set -x

SOURCES_FOLDER="$1" # input directory (example) /e/Git
BUILD_FOLDER="$2"   # output directory (example) /e/Git/build/
BUILD_TYPE="$3"     # Release/Debug
BUILD_SYSTEM="$4"   # Android/Win64/macOS/Linux
PROCESS_BUILD="$5"  # ON/OFF

SOURCE_PROJECT="magnum-integration"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"
GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_SYSTEM}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/install-${BUILD_SYSTEM}-${BUILD_TYPE}

if [ "$BUILD_SYSTEM" = "Android" ]; then
    BUILD_ABI="arm64-v8a" # arm64-v8a/armeabi-v7a (Android only)
    BUILD_LOCATION=${BUILD_LOCATION}-${BUILD_ABI}
fi

mkdir -p "${BUILD_LOCATION}"
rm -rf "${BUILD_LOCATION}"/*

if [ "$BUILD_SYSTEM" = "Android" ] ; then

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
  -DCMAKE_SYSTEM_VERSION=26 \
  -DCMAKE_ANDROID_ARCH_ABI=${BUILD_ABI} \
  -DANDROID_NATIVE_API_LEVEL=26 \
  -DANDROID_ABI=${BUILD_ABI} \
  -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
  -DCMAKE_ANDROID_STL_TYPE=c++_static \
  -DCMAKE_FIND_ROOT_PATH="${BUILD_FOLDER}/install-${BUILD_SYSTEM}-${BUILD_TYPE}" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
  -DIMGUI_DIR="${SOURCES_FOLDER}/imgui" \
  -DWITH_IMGUI=ON 

#  -D_CORRADE_MODULE_DIR="${ANDROID_NDK}/sysroot/usr/share/cmake/Corrade" \
#  -DMAGNUM_INCLUDE_INSTALL_PREFIX="${ANDROID_NDK}/sysroot/usr" \

elif [ "$BUILD_SYSTEM" = "Win64" ] ; then

GENERATOR="Visual Studio 16 2019"

else #expected Linux x86

ADDITIONAL_CMAKE_PARAMS=""

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

fi

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DIMGUI_DIR="${SOURCES_FOLDER}/imgui" \
  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
  -DWITH_IMGUI=ON \
  -DBUILD_STATIC=ON \
  ${ADDITIONAL_CMAKE_PARAMS}

if [ "$PROCESS_BUILD" = "ON" ]; then
    cd ${BUILD_LOCATION}
    cmake --build . --config ${BUILD_TYPE} --target install
fi