#!/bin/bash
set -e

# Findutils 4.10.0 Build Script
# Based on Linux From Scratch 12.4-systemd

./configure --prefix=/usr \
            --localstatedir=/var/lib/locate

make

make DESTDIR="${DESTDIR}" install
