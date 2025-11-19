#!/bin/bash
set -e

# M4 1.4.20 Build Script
# Based on Linux From Scratch 12.4-systemd

# Check for staging directory argument
if [ -z "$1" ]; then
    echo "Usage: $0 <staging_directory>"
    exit 1
fi

STAGING_DIR="$1"

# Extract source
tar -xf m4-1.4.20.tar.xz
cd m4-1.4.20

# Configure
./configure --prefix=/usr

# Build
make

# Run tests (optional)
make check || true

# Install to staging directory
make DESTDIR="$STAGING_DIR" install

# Cleanup
cd ..
rm -rf m4-1.4.20

echo "M4 1.4.20 installed successfully to $STAGING_DIR"
