#!/bin/bash
set -ex

mkdir build && cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DJSON_VALIDATOR_BUILD_TESTS=OFF \
    -DJSON_VALIDATOR_BUILD_EXAMPLES=OFF \
    ..

make -j${CPU_COUNT}
make install
