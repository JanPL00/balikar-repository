#!/bin/bash
set -e

# xz-utils 5.6.3 Build Script
# Upstream source: xz-5.6.3
# Based on LFS / BLFS

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.6.3

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
