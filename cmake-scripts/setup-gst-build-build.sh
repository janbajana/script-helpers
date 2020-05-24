#!/bin/bash

set -x

SOURCES_FOLDER="$1" # input directory (example) /e/Git/build/
BUILD_FOLDER="$2"   # output directory (example) /e/Git/
BUILD_TYPE="$3"     # Release/Debug
BUILD_SYSTEM="$4"   # Android/Win64/macOS/Linux
PROCESS_BUILD="$5"  # ON/OFF build or configurtion only

SOURCE_PROJECT="gst-build"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"
GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_SYSTEM}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/install-${BUILD_SYSTEM}-${BUILD_TYPE}-test

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

  ADDITIONAL_MESON_PARAMS=" \
      -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake" \
      -DCMAKE_ANDROID_NDK="${ANDROID_NDK_HOME}" \
      -DCMAKE_SYSTEM_NAME=Android \
      -DCMAKE_SYSTEM_VERSION=26 \
      -DCMAKE_ANDROID_ARCH_ABI=${BUILD_ABI} \
      -DANDROID_NATIVE_API_LEVEL=26 \
      -DANDROID_ABI=${BUILD_ABI} \
      -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
      -DCMAKE_ANDROID_STL_TYPE=c++_static \
      -DBUILD_TESTS=OFF \
      -DWITH_INTERCONNECT=OFF
      "

  # If corrade util does not exist on system level you can point it to cutom build.
  # -DCORRADE_RC_EXECUTABLE="/c/Corrade/bin/corrade-rc.exe" \

elif [ "$BUILD_SYSTEM" = "Win64" ] ; then

  GENERATOR="Visual Studio 16 2019"

  ADDITIONAL_MESON_PARAMS=" \
      "

else #expected Linux x86

  BUILD_SYSTEM="x86"

  ADDITIONAL_MESON_PARAMS=" \
      "
  
  export CC=/usr/bin/clang
  export CXX=/usr/bin/clang++

fi

meson setup "${BUILD_LOCATION}" "${SOURCE_LOCATION}" -Dbuildtype="${BUILD_TYPE}"  \
  -Dprefix="${INSTALL_LOCATION}" \
  ${ADDITIONAL_MESON_PARAMS}

if [ "$PROCESS_BUILD" = "ON" ]; then
    meson compile -j6 -C ${BUILD_LOCATION}
    meson install -C ${BUILD_LOCATION}
fi