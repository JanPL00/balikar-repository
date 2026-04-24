#!/bin/bash
set -e

# python3 3.13.3 Build Script
# Based on BLFS

./configure --prefix=/usr           \
            --enable-shared         \
            --with-system-expat     \
            --enable-optimizations

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
