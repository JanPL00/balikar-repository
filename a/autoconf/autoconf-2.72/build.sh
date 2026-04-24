#!/bin/bash
set -e

# autoconf 2.72 Build Script
# Based on BLFS

./configure --prefix=/usr \
            --docdir=/usr/share/doc/autoconf-2.72

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
