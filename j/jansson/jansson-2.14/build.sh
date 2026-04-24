#!/bin/bash
set -e

# jansson 2.14 Build Script

./configure --prefix=/usr \
            --disable-static

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
