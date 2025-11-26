#!/bin/bash
set -e

# Sed 4.9 Build Script
# Based on Linux From Scratch 12.4-systemd

# Check for staging directory argument
if [ -z "$1" ]; then
    echo "Usage: $0 <staging_directory>"
    exit 1
fi

STAGING_DIR="$1"

# Extract source
tar -xf sed-4.9.tar.xz
cd sed-4.9

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
rm -rf sed-4.9

echo "Sed 4.9 installed successfully to $STAGING_DIR"
