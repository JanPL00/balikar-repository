#!/bin/bash
set -e

# Diffutils 3.12 Build Script
# Based on Linux From Scratch 12.4-systemd

# Check for staging directory argument
if [ -z "$1" ]; then
    echo "Usage: $0 <staging_directory>"
    exit 1
fi

STAGING_DIR="$1"

# Extract source
tar -xf diffutils-3.12.tar.xz
cd diffutils-3.12

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
rm -rf diffutils-3.12

echo "Diffutils 3.12 installed successfully to $STAGING_DIR"
