#!/bin/bash
set -e

# Attr 2.5.2 build script based on LFS 12.4

# Configure
./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2

# Build
make

# Install
make DESTDIR=$DESTDIR install
