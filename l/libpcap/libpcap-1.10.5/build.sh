#!/bin/bash
set -e

# Configure
./configure --prefix=/usr

# Build
make -j$(nproc)

# Install
make DESTDIR="${DESTDIR}" install
