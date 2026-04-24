#!/bin/bash
set -e

# automake 1.17 Build Script
# Based on BLFS

./configure --prefix=/usr \
            --docdir=/usr/share/doc/automake-1.17

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
