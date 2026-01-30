#!/bin/bash
set -ex

# Set compiler flags to find headers and libraries in PREFIX
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --disable-static \
    --enable-zlib

#make -j${CPU_COUNT}
make -j1
make install
