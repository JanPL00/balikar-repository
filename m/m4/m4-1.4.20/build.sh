#!/bin/bash
set -e

# M4 1.4.20 Build Script
# Based on Linux From Scratch 12.4-systemd

# Configure
./configure --prefix=/usr

# Build
make

# Install
make DESTDIR="$DESTDIR" install
