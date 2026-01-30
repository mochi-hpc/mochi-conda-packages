#!/bin/bash
set -ex

mkdir build && cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DSOL2_BUILD_LUA=OFF \
    ..

make install
