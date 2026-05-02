#!/bin/bash
set -e

# tmux 3.5a — find ncurses & libevent that balikar installed under the
# active --root (we expect BALIKAR_ROOT to be exported by the caller; it
# falls back to / which means an empty prefix path).
PREFIX_ROOT="${BALIKAR_ROOT:-/}"
DEPROOT="${PREFIX_ROOT%/}/usr"

export PKG_CONFIG_PATH="${DEPROOT}/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
export CPPFLAGS="-I${DEPROOT}/include -I${DEPROOT}/include/ncursesw ${CPPFLAGS}"
export LDFLAGS="-L${DEPROOT}/lib -Wl,-rpath,${DEPROOT}/lib ${LDFLAGS}"

# Bypass pkg-config probes: tmux's configure honours these env vars and
# skips the failing ncurses/tinfo detection that returns "no" even when
# the library is present (configure's link test needs explicit -lncursesw).
export LIBNCURSES_CFLAGS="-I${DEPROOT}/include"
export LIBNCURSES_LIBS="-L${DEPROOT}/lib -lncursesw"
export LIBTINFO_CFLAGS="-I${DEPROOT}/include"
export LIBTINFO_LIBS="-L${DEPROOT}/lib -lncursesw"
export LIBEVENT_CFLAGS="-I${DEPROOT}/include"
export LIBEVENT_LIBS="-L${DEPROOT}/lib -levent"

./configure --prefix=/usr --enable-static

make -j$(nproc)

make DESTDIR="$DESTDIR" install
