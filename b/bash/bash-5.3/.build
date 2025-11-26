#!/bin/bash
set -e

# Bash 5.3 build script based on LFS 12.4

# Set paths for installed readline if using staging directory
if [ -n "$DESTDIR" ]; then
    export CPPFLAGS="-I$DESTDIR/usr/include"
    # Use -Wl,-rpath-link to find readline at build-time without breaking system libs
    export LDFLAGS="-Wl,-rpath-link,$DESTDIR/usr/lib"
fi

# Configure
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.3

# Build
make

# Install
if [ -n "$DESTDIR" ]; then
    make DESTDIR=$DESTDIR install
else
    make install
fi
