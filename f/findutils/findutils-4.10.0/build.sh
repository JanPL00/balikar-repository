#!/bin/bash
set -e

# Findutils 4.10.0 Build Script
# Based on Linux From Scratch 12.4-systemd

# Check for staging directory argument
if [ -z "$1" ]; then
    echo "Usage: $0 <staging_directory>"
    exit 1
fi

STAGING_DIR="$1"

# Extract source
tar -xf findutils-4.10.0.tar.xz
cd findutils-4.10.0

# Configure
./configure --prefix=/usr \
            --localstatedir=/var/lib/locate

# Build
make

# Run tests (optional)
chown -R tester . 2>/dev/null || true
su tester -c "PATH=$PATH make check" 2>/dev/null || make check || true

# Install to staging directory
make DESTDIR="$STAGING_DIR" install

# Cleanup
cd ..
rm -rf findutils-4.10.0

echo "Findutils 4.10.0 installed successfully to $STAGING_DIR"
