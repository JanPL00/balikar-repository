#!/bin/bash
set -e

# Tar 1.35 build script based on LFS 12.4

# Configure
./configure --prefix=/usr

# Build
make

# Install
make DESTDIR=$DESTDIR install

# Install documentation
make -C doc DESTDIR=$DESTDIR install-html docdir=/usr/share/doc/tar-1.35
