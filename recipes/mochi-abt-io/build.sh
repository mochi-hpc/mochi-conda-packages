#!/bin/bash
set -ex

# Set pkg-config path for host dependencies
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
export CMAKE_PREFIX_PATH=$PREFIX:$CMAKE_PREFIX_PATH

# Convert true/false to enable/disable for configure
if [ "$io_uring" = "true" ]; then LIBURING="ON"; else LIBURING="OFF"; fi
if [ "$bedrock" = "true" ]; then BEDROCK="ON"; else BEDROCK="OFF"; fi

mkdir build && cd build

cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX \
         -DENABLE_BEDROCK=$BEDROCK \
         -DENABLE_LIBURING=$LIBURING \
         ${CMAKE_ARGS}

make -j${CPU_COUNT}
make install
