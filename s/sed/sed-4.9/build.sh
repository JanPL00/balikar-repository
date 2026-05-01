#!/bin/bash
set -e

# Sed 4.9 Build Script
# Based on Linux From Scratch 12.4-systemd

./configure --prefix=/usr

make

make DESTDIR="${DESTDIR}" install
