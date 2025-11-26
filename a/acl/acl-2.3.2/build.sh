#!/bin/bash
set -e

# ACL 2.3.2 build script based on LFS 12.4

# Configure
./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/acl-2.3.2

# Build
make

# Install
make DESTDIR=$DESTDIR install
