#!/bin/bash
set -e

# libtool 2.4.7 Build Script
# Based on BLFS

./configure --prefix=/usr \
            --docdir=/usr/share/doc/libtool-2.4.7

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
