#!/bin/bash

set -x

SOURCES_FOLDER="$1"
BUILD_FOLDER="$2"
BUILD_TYPE="$3" #Release/Debug
BUILD_ARCH="$4" #Android/AndroidGradle/Win64/linux
SOURCE_PROJECT="magnum-bootstrap"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"
GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_ARCH}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}

mkdir -p "${BUILD_LOCATION}"
rm -rf "${BUILD_LOCATION}"/*

if [ "$BUILD_ARCH" = "Android" ] ; then

# https://doc.magnum.graphics/magnum/platforms-android.html
# https://doc.magnum.graphics/magnum/classMagnum_1_1Platform_1_1AndroidApplication.html#Platform-AndroidApplication-bootstrap

ANDROID_NDK=${HOME}/AppData/Local/Android/Sdk/ndk/20.0.5594570
#INSTALL_LOCATION=${ANDROID_NDK}/platforms/android-22/arch-arm64/usr

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DCMAKE_PREFIX_PATH="${INSTALL_LOCATION}" \
  -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
  -DCMAKE_ANDROID_NDK=${ANDROID_NDK} \
  -DCMAKE_SYSTEM_NAME=Android \
  -DCMAKE_SYSTEM_VERSION=26 \
  -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a \
  -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
  -DANDROID_TOOLCHAIN=clang \
  -DCMAKE_ANDROID_STL_TYPE=c++_static \
  -DCORRADE_RC_EXECUTABLE="/c/Corrade/bin/corrade-rc.exe" \
  -DCMAKE_FIND_ROOT_PATH="${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}"

  # -D_CORRADE_MODULE_DIR="${ANDROID_NDK}/sysroot/usr/share/cmake/Corrade"
  
elif [ "$BUILD_ARCH" = "AndroidGradle" ] ; then

cd ${SOURCE_LOCATION}

export JAVA_HOME="/c/Program Files/Android/Android Studio/jre"
export ANDROID_HOME=${HOME}/AppData/Local/Android/Sdk
export ANDROID_NDK_HOME=${HOME}/AppData/Local/Android/Sdk/ndk/20.0.5594570
export CMAKE_PREFIX_PATH="${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE};${BUILD_FOLDER}/install-Win64-Release"
/c/Gradle/gradle-4.1/bin/gradle build --stacktrace

elif [ "$BUILD_ARCH" = "Win64" ] ; then

ADDITIONAL_CMAKE_PARAMS=""
GENERATOR="Visual Studio 15 2017 Win64"

else

ADDITIONAL_CMAKE_PARAMS=""
BUILD_ARCH="x86"
#export CC=/usr/bin/clang
#export CXX=/usr/bin/clang++

fi

#cd ${BUILD_LOCATION}
#cmake --build . --config ${BUILD_TYPE}
#cmake --build . --config ${BUILD_TYPE} --target install