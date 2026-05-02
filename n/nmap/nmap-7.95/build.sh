#!/bin/bash
set -e

# nmap 7.95 — fully self-contained build using the bundled libpcap, libpcre,
# libdnet, liblua and libz. No openssl, no libssh2, no zenmap/ndiff GUI bits.
# This avoids pulling in heavy native dependencies and keeps the package
# installable on a minimal Debian image with just gcc/make/bash.

./configure --prefix=/usr            \
            --without-zenmap         \
            --without-ndiff          \
            --without-nmap-update    \
            --without-openssl        \
            --without-libssh2        \
            --with-libpcap=included  \
            --with-libpcre=included  \
            --with-libdnet=included  \
            --with-liblua=included   \
            --with-libz=included

make -j$(nproc)

make DESTDIR="$DESTDIR" install
