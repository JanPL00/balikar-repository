#!/bin/bash
set -e

# gxx — virtual build-time package providing g++ (C++ compiler).
# Installs g++ from the host's apt cache so other balikar packages
# (e.g. nmap, which is C++) can compile without modifying the Dockerfile.
# No files are placed under DESTDIR; this package only side-effects the
# build host and leaves an installed-marker via balikar metadata.

if ! command -v g++ >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
        echo "gxx: installing g++ via apt-get"
        apt-get update -qq
        apt-get install -y --no-install-recommends g++
    else
        echo "gxx: no apt-get available and g++ not present" >&2
        exit 1
    fi
fi

# Drop a small marker file into the staging directory so the package has
# something to install (balikar refuses empty packages otherwise).
mkdir -p "$DESTDIR/usr/share/balikar/gxx"
g++ --version | head -1 > "$DESTDIR/usr/share/balikar/gxx/version.txt"
