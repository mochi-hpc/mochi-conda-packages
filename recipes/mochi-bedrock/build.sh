#!/bin/bash
set -ex

# Set pkg-config path for host dependencies
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Convert true/false to ON/OFF for CMake
if [ "$flock" = "true" ]; then FLOCK=ON; else FLOCK=OFF; fi
if [ "$use_mpi" = "true" ]; then MPI=ON; else MPI=OFF; fi

mkdir build && cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DENABLE_FLOCK=${FLOCK} \
    -DENABLE_MPI=${MPI} \
    -DENABLE_PYTHON=ON \
    -DENABLE_SPACE=OFF \
    -DENABLE_TESTS=OFF \
    -DENABLE_EXAMPLES=OFF \
    ..

make -j${CPU_COUNT}
make install
