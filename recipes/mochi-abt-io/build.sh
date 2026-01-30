#!/bin/bash
set -ex

# Set pkg-config path for host dependencies
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Set compiler flags to find headers and libraries in PREFIX
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Generate configure script
autoreconf -fi

# Convert true/false to enable/disable for configure
if [ "$io_uring" = "true" ]; then LIBURING="--enable-liburing"; else LIBURING="--disable-liburing"; fi

./configure \
    --prefix=$PREFIX \
    --disable-bedrock \
    --with-zlib=$PREFIX \
    ${LIBURING}

make -j${CPU_COUNT}
make install
