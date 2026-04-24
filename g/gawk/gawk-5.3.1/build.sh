#!/bin/bash
set -e

# gawk 5.3.1 Build Script
# Based on LFS / BLFS

./configure --prefix=/usr \
            --sysconfdir=/etc

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
