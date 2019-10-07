#!/bin/bash

set -x

SOURCES_FOLDER="$1" # input directory (example) /e/Git/build/
BUILD_FOLDER="$2" # output directory (example) /e/Git/
BUILD_TYPE="$3" # Release/Debug
BUILD_ARCH="$4" # Android/Win64/linux
SOURCE_PROJECT="magnum"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"
GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_ARCH}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}

mkdir -p "${BUILD_LOCATION}"
rm -rf "${BUILD_LOCATION}"/*

if [ "$BUILD_ARCH" = "Android" ] ; then

ANDROID_NDK=${HOME}/AppData/Local/Android/Sdk/ndk/20.0.5594570
INSTALL_LOCATION=${ANDROID_NDK}/platforms/android-22/arch-arm64/usr

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    -G"${GENERATOR}" \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
    -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
    -DCMAKE_ANDROID_NDK="${ANDROID_NDK}" \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=22 \
    -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a \
    -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
    -DCMAKE_ANDROID_STL_TYPE=c++_static \
    -DCORRADE_RC_EXECUTABLE="/c/Corrade/bin/corrade-rc.exe" \
    -DMAGNUM_INCLUDE_INSTALL_PREFIX="${ANDROID_NDK}/sysroot/usr" \
    -DCMAKE_FIND_ROOT_PATH="${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
    -D_CORRADE_MODULE_DIR="${ANDROID_NDK}/sysroot/usr/share/cmake/Corrade" \
    -DWITH_AUDIO=OFF \
    -DWITH_DEBUGTOOLS=OFF \
    -DWITH_MESHTOOLS=OFF \
    -DWITH_PRIMITIVES=OFF \
    -DWITH_SCENEGRAPH=OFF \
    -DWITH_SHADERS=OFF \
    -DWITH_TEXT=OFF \
    -DWITH_TEXTURETOOLS=OFF \
    -DWITH_TRADE=OFF \
    -DWITH_ANDROIDAPPLICATION=ON \
    -DTARGET_GLES2=ON \
    -DBUILD_DEPRECATED=OFF

#    -DMAGNUM_INCLUDE_INSTALL_PREFIX=${ANDROID_NDK}/sysroot/usr \

elif [ "$BUILD_ARCH" = "Win64" ] ; then

GENERATOR="Visual Studio 15 2017 Win64"

ADDITIONAL_CMAKE_PARAMS=" \
    -DWITH_SDL2APPLICATION=ON \
    -DWITH_GLFWAPPLICATION=OFF \
    "

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DCMAKE_PREFIX_PATH="${BUILD_FOLDER}\SDL2-2.0.10" \
  -DCMAKE_FIND_ROOT_PATH="${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
  -DBUILD_TESTS=OFF \
  ${ADDITIONAL_CMAKE_PARAMS}

else #expected Linux x86

ADDITIONAL_CMAKE_PARAMS=" \
    -DWITH_SDL2APPLICATION=ON"
BUILD_ARCH="x86"
#export CC=/usr/bin/clang
#export CXX=/usr/bin/clang++

fi

#cd ${BUILD_LOCATION}
#cmake --build . --config ${BUILD_TYPE}
#cmake --build . --target install --config ${BUILD_TYPE}
