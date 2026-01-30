#!/bin/bash
set -ex

# Set pkg-config path for host dependencies
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Convert true/false to ON/OFF for CMake
if [ "$ofi" = "true" ]; then OFI=ON; else OFI=OFF; fi
if [ "$hwloc" = "true" ]; then HWLOC=ON; else HWLOC=OFF; fi
if [ "$use_ucx" = "true" ]; then UCX=ON; else UCX=OFF; fi
if [ "$checksum" = "true" ]; then CHECKSUM=ON; else CHECKSUM=OFF; fi

mkdir build && cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DNA_USE_SM=ON \
    -DNA_USE_BMI=OFF \
    -DNA_USE_MPI=OFF \
    -DNA_USE_PSM=OFF \
    -DNA_USE_PSM2=OFF \
    -DMERCURY_USE_SYSTEM_BOOST=OFF \
    -DMERCURY_USE_BOOST_PP=ON \
    -DMERCURY_USE_CHECKSUMS=${CHECKSUM} \
    -DBUILD_TESTING=OFF \
    -DNA_USE_OFI=${OFI} \
    -DNA_OFI_USE_HWLOC=${HWLOC} \
    -DNA_USE_UCX=${UCX} \
    -DNA_OFI_GNI_USE_UDREG=OFF \
    ..

make -j${CPU_COUNT}
make install
