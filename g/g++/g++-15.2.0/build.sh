#!/bin/bash
set -e

# g++ 15.2.0 Build Script
# C++ compiler frontend from GCC source tree

mkdir -v build
cd build

../configure                                     \
    --prefix=/usr                                \
    --enable-languages=c++                       \
    --enable-default-pie                         \
    --enable-default-ssp                         \
    --enable-host-pie                            \
    --disable-multilib                           \
    --disable-bootstrap                          \
    --disable-fixincludes                        \
    --with-system-zlib

make -j$(nproc)

make DESTDIR="${DESTDIR}" install

# Remove files already provided by gcc
rm -f "${DESTDIR}/usr/lib/libgcc_s.so"*
rm -f "${DESTDIR}/usr/lib/libgcc_s.so.1"
