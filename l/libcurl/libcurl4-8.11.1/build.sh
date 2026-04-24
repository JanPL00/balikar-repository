#!/bin/bash
set -e

# libcurl4 8.11.1 Build Script
# Upstream source: curl-8.11.1
# Based on BLFS

./configure --prefix=/usr        \
            --disable-static     \
            --enable-threaded-resolver \
            --with-openssl       \
            --with-zlib          \
            --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
