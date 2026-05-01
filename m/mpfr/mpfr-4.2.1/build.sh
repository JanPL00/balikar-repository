#!/bin/bash
set -e

# MPFR 4.2.1 build script based on LFS 12.4

# Configure
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.1

# Build
make
make html

# Install
make DESTDIR=$DESTDIR install
make DESTDIR=$DESTDIR install-html
