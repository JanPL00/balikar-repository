#!/bin/bash
set -e

# xz 5.6.3 Build Script

# Install to /usr/local with static linking. This avoids overwriting the
# system /usr/bin/xz (which is needed by tar to extract subsequent .xz
# archives during the same balikar session) and avoids depending on a
# liblzma shared library that may not be on the runtime loader path yet.
./configure --prefix=/usr/local \
            --enable-static  \
            --disable-shared \
            --docdir=/usr/local/share/doc/xz-5.6.3

make -j$(nproc)

make DESTDIR="${DESTDIR}" install
