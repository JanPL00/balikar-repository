#!/bin/bash
set -e

# Bison 3.8.2 Build Script
# Based on Linux From Scratch 12.4-systemd

# Check for staging directory argument
if [ -z "$1" ]; then
    echo "Usage: $0 <staging_directory>"
    exit 1
fi

STAGING_DIR="$1"

# Extract source
tar -xf bison-3.8.2.tar.xz
cd bison-3.8.2

# Configure
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2

# Build
make

# Run tests (optional)
make check || true

# Install to staging directory
make DESTDIR="$STAGING_DIR" install

# Cleanup
cd ..
rm -rf bison-3.8.2

echo "Bison 3.8.2 installed successfully to $STAGING_DIR"
