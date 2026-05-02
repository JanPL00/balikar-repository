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

# Refresh timestamps on autotools-generated files in bundled libpcre so
# make does not try to re-run aclocal/autoconf/automake (none of which are
# present on a minimal Debian image). Order matters: configure.ac must be
# OLDER than the generated files (aclocal.m4, configure, Makefile.in, ...).
if [ -d libpcre ]; then
    (
        cd libpcre
        # Bump generated files to "now"; sleep so configure.ac stays older.
        touch configure.ac configure.in 2>/dev/null || true
        sleep 1
        touch aclocal.m4 configure Makefile.am Makefile.in \
              config.h.in src/config.h.in 2>/dev/null || true
    )
fi

make -j$(nproc)

make DESTDIR="$DESTDIR" install
