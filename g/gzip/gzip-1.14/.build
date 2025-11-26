#!/bin/bash
set -e

# Gzip 1.14 build script based on LFS 12.4

# Configure
./configure --prefix=/usr

# Build
make

# Install
make DESTDIR=$DESTDIR install
