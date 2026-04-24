#!/bin/bash
set -e

# libarchive13 3.7.7 Build Script
# Upstream source: libarchive-3.7.7
# Based on BLFS

./configure --prefix=/usr   \
            --disable-static

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
