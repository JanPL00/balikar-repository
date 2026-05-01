#!/bin/bash
set -e

# Grep 3.12 Build Script
# Based on Linux From Scratch 12.4-systemd

./configure --prefix=/usr

make

make DESTDIR="${DESTDIR}" install
