#!/bin/bash
set -ex

# Set compiler flags to find headers and libraries in PREFIX
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Build PMDK (without docs and without ndctl/daxctl)
make -j${CPU_COUNT} \
    prefix=$PREFIX \
    NDCTL_ENABLE=n \
    BUILD_EXAMPLES=n \
    BUILD_BENCHMARKS=n \
    DOC=n

make install \
    prefix=$PREFIX \
    NDCTL_ENABLE=n \
    BUILD_EXAMPLES=n \
    BUILD_BENCHMARKS=n \
    DOC=n
