#!/bin/bash

set -x

SOURCES_FOLDER="$1"   # source directory (example) /d/Work/Git

SOURCE_LOCATION="${SOURCES_FOLDER}"

# ...
SOURCE_PROJECT="SDL"
hg clone http://hg.libsdl.org/${SOURCE_PROJECT} ${SOURCE_LOCATION}/${SOURCE_PROJECT}

# ..
SOURCE_PROJECT="assimp"
cd ${CURRENT_LOCATION}
git clone --depth 1 git@github.com:assimp/${SOURCE_PROJECT}.git ${SOURCE_LOCATION}/${SOURCE_PROJECT}

# ..
SOURCE_PROJECT="imgui"
git clone --depth 1 git@github.com:ocornut/${SOURCE_PROJECT}.git ${SOURCE_LOCATION}/${SOURCE_PROJECT}

# ...
SOURCE_PROJECT="corrade"
git clone --depth 1 git://github.com/mosra/${SOURCE_PROJECT}.git ${SOURCE_LOCATION}/${SOURCE_PROJECT}

# ...
SOURCE_PROJECT="magnum"
git clone --depth 1 git://github.com/mosra/${SOURCE_PROJECT}.git ${SOURCE_LOCATION}/${SOURCE_PROJECT}

# ...
SOURCE_PROJECT="magnum-integration"
git clone --depth 1 git://github.com/mosra/${SOURCE_PROJECT}.git ${SOURCE_LOCATION}/${SOURCE_PROJECT}

# ...
SOURCE_PROJECT="magnum-plugins"
git clone --depth 1 git://github.com/mosra/${SOURCE_PROJECT}.git ${SOURCE_LOCATION}/${SOURCE_PROJECT}

# ...
SOURCE_PROJECT="magnum-extras"
git clone --depth 1 git://github.com/mosra/${SOURCE_PROJECT}.git ${SOURCE_LOCATION}/${SOURCE_PROJECT}

# ...
SOURCE_PROJECT="magnum-examples"
git clone --depth 1 git://github.com/mosra/${SOURCE_PROJECT}.git ${SOURCE_LOCATION}/${SOURCE_PROJECT}

