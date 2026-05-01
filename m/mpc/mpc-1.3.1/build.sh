#!/bin/bash
set -e

# MPC 1.3.1 build script based on LFS 12.4

# Configure
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1

# Build
make
make html

# Install
make DESTDIR=$DESTDIR install
make DESTDIR=$DESTDIR install-html
