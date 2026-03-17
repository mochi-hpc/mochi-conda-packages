#!/bin/bash
set -ex

# Set pkg-config path for host dependencies
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Set CMAKE_PREFIX_PATH to help find cmake config files
export CMAKE_PREFIX_PATH=$PREFIX:$CMAKE_PREFIX_PATH

# Convert true/false to ON/OFF for CMake
if [ "$bedrock" = "true" ]; then BEDROCK=ON; else BEDROCK=OFF; fi
if [ "$use_lua" = "true" ]; then LUA=ON; else LUA=OFF; fi

# Handle backend variant
BERKELEYDB=OFF
GDBM=OFF
LEVELDB=OFF
LMDB=OFF
ROCKSDB=OFF
TKRZW=OFF
UNQLITE=OFF

case "$backend" in
    "all")
        BERKELEYDB=ON
        GDBM=ON
        LEVELDB=ON
        LMDB=ON
        ROCKSDB=ON
        TKRZW=ON
        UNQLITE=ON
        ;;
    "berkeleydb")
        BERKELEYDB=ON
        ;;
    "gdbm")
        GDBM=ON
        ;;
    "leveldb")
        LEVELDB=ON
        ;;
    "lmdb")
        LMDB=ON
        ;;
    "rocksdb")
        ROCKSDB=ON
        ;;
    "tkrzw")
        TKRZW=ON
        ;;
    "unqlite")
        UNQLITE=ON
        ;;
    "none"|*)
        # All backends stay OFF
        ;;
esac

# Add missing leveldb.pc file
if [ $LEVELDB = "ON" ]; then
cat <<EOT > $PREFIX/lib/pkgconfig/leveldb.pc
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${prefix}/lib
includedir=\${prefix}/include

Name: leveldb
Description: LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from   string keys to string values.
Version: 1.22
Cflags: -I\${includedir}
Libs: -L]\${libdir} -lleveldb
EOT
fi

# Add missing leveldb.pc file
if [ $LMDB = "ON" ]; then
cat <<EOT > $PREFIX/lib/pkgconfig/lmdb.pc
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${prefix}/lib
includedir=\${prefix}/include

Name: leveldb
Description: Symas LMDB is an extraordinarily fast, memory-efficient database.
Version: 0.9.31
Cflags: -I\${includedir}
Libs: -L]\${libdir} -llmdb
EOT
fi

# Remove sol2 dependency from config (not needed when Lua is disabled)
sed -i '/find_dependency (sol2)/d' src/yokan-config.cmake.in

mkdir build && cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DENABLE_BEDROCK=${BEDROCK} \
    -DENABLE_LUA=${LUA} \
    -DENABLE_PYTHON=ON \
    -DENABLE_REMI=OFF \
    -DENABLE_BERKELEYDB=${BERKELEYDB} \
    -DENABLE_GDBM=${GDBM} \
    -DENABLE_LEVELDB=${LEVELDB} \
    -DENABLE_LMDB=${LMDB} \
    -DENABLE_ROCKSDB=${ROCKSDB} \
    -DENABLE_TKRZW=${TKRZW} \
    -DENABLE_UNQLITE=${UNQLITE} \
    -DENABLE_TESTS=OFF \
    -DENABLE_EXAMPLES=OFF \
    ..

make -j${CPU_COUNT}
make install
