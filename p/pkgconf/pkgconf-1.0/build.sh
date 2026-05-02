#!/bin/bash
set -e
if ! command -v pkg-config >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
        echo "pkgconf: installing pkg-config via apt-get"
        apt-get update -qq
        apt-get install -y --no-install-recommends pkg-config
    else
        echo "pkgconf: no apt-get available" >&2
        exit 1
    fi
fi
mkdir -p "$DESTDIR/usr/share/balikar/pkgconf"
pkg-config --version > "$DESTDIR/usr/share/balikar/pkgconf/version.txt"
