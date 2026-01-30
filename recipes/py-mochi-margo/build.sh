#!/bin/bash
set -ex

# Set pkg-config path for host dependencies
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
