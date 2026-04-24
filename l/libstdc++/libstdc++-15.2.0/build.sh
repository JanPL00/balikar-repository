#!/bin/bash
set -e

# libstdc++ 15.2.0 Build Script
# GCC C++ standard library (built from GCC source tree)

mkdir -v build
cd build

../configure                                     \
    --prefix=/usr                                \
    --enable-languages=c,c++                     \
    --enable-default-pie                         \
    --enable-default-ssp                         \
    --enable-host-pie                            \
    --disable-multilib                           \
    --disable-bootstrap                          \
    --disable-fixincludes                        \
    --with-system-zlib

make -j$(nproc)

# Install only libstdc++ runtime library
make DESTDIR="${DESTDIR}" install-target-libstdc++-v3
