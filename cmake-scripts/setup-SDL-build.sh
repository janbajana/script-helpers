#!/bin/bash

set -x

SOURCES_FOLDER="$1" # input directory (example) /e/Git/build/
BUILD_FOLDER="$2"   # output directory (example) /e/Git/
BUILD_TYPE="$3"     # Release/Debug
BUILD_ARCH="$4"     # Android/Win64/Linux
PROCESS_BUILD="$5"  # ON/OFF build or configurtion only

SOURCE_PROJECT="SDL"
SOURCE_LOCATION="${SOURCES_FOLDER}/${SOURCE_PROJECT}"
GENERATOR="Ninja"

BUILD_LOCATION=${BUILD_FOLDER}/${SOURCE_PROJECT}-build-${BUILD_ARCH}-${BUILD_TYPE}
INSTALL_LOCATION=${BUILD_FOLDER}/install-${BUILD_ARCH}-${BUILD_TYPE}

mkdir -p "${BUILD_LOCATION}"
rm -rf "${BUILD_LOCATION}"/*

if [ "$BUILD_ARCH" = "Win64" ] ; then

  GENERATOR="Visual Studio 16 2019"

  ADDITIONAL_CMAKE_PARAMS=" \
      -DWITH_INTERCONNECT=ON \
      "

else #expected Linux x86

  BUILD_ARCH="x86"

  ADDITIONAL_CMAKE_PARAMS=" \
      -DWITH_INTERCONNECT=ON \
      "
  
  export CC=/usr/bin/clang
  export CXX=/usr/bin/clang++

fi

cmake -B"${BUILD_LOCATION}" -H"${SOURCE_LOCATION}" -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -G"${GENERATOR}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_LOCATION}" \
  -DBUILD_STATIC=ON \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="bin" \
  -DSDL_STATIC=ON \
  -DSDL_SHARED=OFF \
  ${ADDITIONAL_CMAKE_PARAMS}

if [ "$PROCESS_BUILD" = "ON" ]; then
    cd ${BUILD_LOCATION}
    cmake --build . --config ${BUILD_TYPE} --target install
fi