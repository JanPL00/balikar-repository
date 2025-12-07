#!/bin/bash
# OpenSSL build script based on LFS 12.2
set -e

# Configure according to LFS
./config \
    --prefix=/usr \
    --openssldir=/etc/ssl \
    --libdir=lib \
    shared \
    zlib-dynamic

# Build
make -j$(nproc)

# Run tests (optional, commented out for speed)
# make test

# Install to DESTDIR
make DESTDIR="${DESTDIR}" install

# Create compatibility symlink for documentation
install -vdm755 "${DESTDIR}/usr/share/doc/openssl-3.4.0"
cp -vfr doc/* "${DESTDIR}/usr/share/doc/openssl-3.4.0/" || true
