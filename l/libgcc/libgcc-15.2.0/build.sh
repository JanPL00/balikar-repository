#!/bin/bash
set -e

# libgcc 15.2.0 Build Script
# GCC runtime library (built from GCC source tree)

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

# Install only libgcc runtime libraries
make DESTDIR="${DESTDIR}" install-target-libgcc
