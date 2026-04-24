#!/bin/bash
set -e

# musl-dev 1.2.5 Build Script
# musl libc development headers and static library

./configure --prefix=/usr \
            --syslibdir=/lib

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
