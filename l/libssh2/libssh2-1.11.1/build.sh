#!/bin/bash
set -e

# Configure
./configure \
    --prefix=/usr \
    --with-openssl \
    --with-libz

# Build
make -j$(nproc)

# Install
make DESTDIR="${DESTDIR}" install
