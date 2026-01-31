#!/bin/bash
set -ex

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
export CMAKE_PREFIX_PATH=$PREFIX:$CMAKE_PREFIX_PATH

mkdir build && cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_PYTHON=ON \
    -DENABLE_TESTS=OFF \
    -DENABLE_BENCHMARKS=OFF \
    ..

make -j${CPU_COUNT}
make install
