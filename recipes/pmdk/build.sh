#!/bin/bash
set -ex

# Set compiler flags to find headers and libraries in PREFIX
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Detect architecture (pmdk Makefile doesn't always detect x86_64 correctly)
ARCH_FLAG=""
if [ "$(uname -m)" = "x86_64" ]; then
    ARCH_FLAG="ARCH=x86_64"
fi

# Build PMDK (without docs and without ndctl/daxctl)
make -j${CPU_COUNT} \
    prefix=$PREFIX \
    NDCTL_ENABLE=n \
    BUILD_EXAMPLES=n \
    BUILD_BENCHMARKS=n \
    DOC=n \
    $ARCH_FLAG

make install \
    prefix=$PREFIX \
    NDCTL_ENABLE=n \
    BUILD_EXAMPLES=n \
    BUILD_BENCHMARKS=n \
    DOC=n \
    $ARCH_FLAG
