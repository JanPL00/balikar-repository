#!/bin/bash
set -e

# Make 4.4.1 Build Script
# Based on Linux From Scratch 12.4-systemd

# Check for staging directory argument
if [ -z "$1" ]; then
    echo "Usage: $0 <staging_directory>"
    exit 1
fi

STAGING_DIR="$1"

# Extract source
tar -xf make-4.4.1.tar.gz
cd make-4.4.1

# Configure
./configure --prefix=/usr

# Build
make

# Run tests (optional)
# Note: Tests may take a while
chown -R tester . 2>/dev/null || true
su tester -c "PATH=$PATH make check" 2>/dev/null || make check || true

# Install to staging directory
make DESTDIR="$STAGING_DIR" install

# Cleanup
cd ..
rm -rf make-4.4.1

echo "Make 4.4.1 installed successfully to $STAGING_DIR"
