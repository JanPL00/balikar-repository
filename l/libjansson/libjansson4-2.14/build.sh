#!/bin/bash
set -e

# libjansson4 2.14 Build Script
# Upstream source: jansson-2.14

./configure --prefix=/usr \
            --disable-static

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
