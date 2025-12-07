#!/bin/bash
set -e

# Configure nmap with /usr prefix (default is /usr/local)
# Libraries (openssl, libpcap, etc.) will be auto-detected
./configure --prefix=/usr --without-zenmap

# Build nmap
make

# Install to DESTDIR staging area
make DESTDIR="${DESTDIR}" install
