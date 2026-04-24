#!/bin/bash
set -e

# gcompat 1.1.0 Build Script
# glibc compatibility layer for musl-based systems

make DESTDIR="${DESTDIR}" LINKER_PATH=/lib/ld-musl-x86_64.so.1 install
