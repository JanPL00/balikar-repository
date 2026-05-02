#!/bin/bash
set -e

# libevent 2.1.12. Upstream tarball name has the "-stable" suffix and balikar
# extracts using the package version (libevent-2.1.12), so handle either
# resulting source directory layout transparently.
if [ -d ../libevent-2.1.12-stable ] && [ ! -f ./configure ]; then
    cd ../libevent-2.1.12-stable
fi
if [ -f ./configure ]; then :; elif [ -d libevent-2.1.12-stable ]; then cd libevent-2.1.12-stable; fi

./configure --prefix=/usr --disable-openssl

make -j$(nproc)

make DESTDIR="$DESTDIR" install
