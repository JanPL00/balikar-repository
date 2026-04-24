#!/bin/bash
set -e

# flex 2.6.4 Build Script
# Based on LFS

./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
