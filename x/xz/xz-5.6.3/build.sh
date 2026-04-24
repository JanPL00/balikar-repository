#!/bin/bash
set -e

# xz 5.6.3 Build Script

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.6.3

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
