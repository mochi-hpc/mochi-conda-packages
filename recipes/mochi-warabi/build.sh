#!/bin/bash
set -ex

# Set pkg-config path for host dependencies
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Convert true/false to ON/OFF for CMake
if [ "$bedrock" = "true" ]; then BEDROCK=ON; else BEDROCK=OFF; fi

mkdir build && cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_BEDROCK=${BEDROCK} \
    -DENABLE_PYTHON=ON \
    -DENABLE_REMI=OFF \
    -DENABLE_SPACE=OFF \
    -DENABLE_TESTS=OFF \
    -DENABLE_EXAMPLES=OFF \
    ..

make -j${CPU_COUNT}
make install
