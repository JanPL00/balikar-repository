#!/bin/bash
set -e

# bzip2 1.0.8 Build Script
# bzip2 does not use autoconf; uses a hand-written Makefile

# Build shared library
make -f Makefile-libbz2_so

# Build static tools
make -j$(nproc)

# Install to staging directory
make PREFIX="${DESTDIR}/usr" install

# Install shared library manually
install -vDm755 libbz2.so.1.0.8 "${DESTDIR}/usr/lib/libbz2.so.1.0.8"
ln -sfv libbz2.so.1.0.8 "${DESTDIR}/usr/lib/libbz2.so.1.0"
ln -sfv libbz2.so.1.0.8 "${DESTDIR}/usr/lib/libbz2.so"

# Remove static library if present
rm -fv "${DESTDIR}/usr/lib/libbz2.a"
