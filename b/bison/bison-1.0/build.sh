#!/bin/bash
set -e

# bison — virtual build-time package providing yacc/bison.
# Installs from the host's apt cache; needed by tmux, etc.

if ! command -v yacc >/dev/null 2>&1 && ! command -v bison >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
        echo "bison: installing bison via apt-get"
        apt-get update -qq
        apt-get install -y --no-install-recommends bison
    else
        echo "bison: no apt-get available and bison not present" >&2
        exit 1
    fi
fi

mkdir -p "$DESTDIR/usr/share/balikar/bison"
(bison --version 2>/dev/null || yacc --version 2>/dev/null || echo "bison/yacc") | head -1 > "$DESTDIR/usr/share/balikar/bison/version.txt"
