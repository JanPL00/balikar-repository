#!/bin/bash
set -e

# ncurses 6.5 - widechar build into /usr (DESTDIR controlled by balikar)
# Provides libncursesw + symlinks expected by tmux's configure.

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-widec          \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig

make -j$(nproc)

make DESTDIR="$DESTDIR" install

# Drop the /usr/lib/terminfo symlink (Debian hosts already have a real dir
# at this path, which would break a later cp -a into the chroot).
rm -f "$DESTDIR/usr/lib/terminfo"

# Compatibility symlinks so packages looking for non-wide names resolve to
# the wide-character libraries we just installed.
for lib in ncurses form panel menu; do
    ln -sfv lib${lib}w.so "$DESTDIR/usr/lib/lib${lib}.so"
    ln -sfv ${lib}w.pc    "$DESTDIR/usr/lib/pkgconfig/${lib}.pc"
done
ln -sfv libncursesw.so "$DESTDIR/usr/lib/libcurses.so"
