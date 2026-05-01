#!/bin/bash
set -e

# Bison 3.8.2 Build Script
# Based on Linux From Scratch 12.4-systemd

./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2

make

make DESTDIR="${DESTDIR}" install
