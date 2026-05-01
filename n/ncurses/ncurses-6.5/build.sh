#!/bin/bash
set -e

# Ncurses 6.5 build script based on LFS 12.4

# Configure
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig

# Build
make

# Install
make DESTDIR=$DESTDIR install

# ncurses creates $DESTDIR/usr/lib/terminfo as a compatibility symlink to
# /usr/share/terminfo. On Debian-based systems /usr/lib/terminfo is already
# a real directory, so cp -a would fail with "cannot overwrite directory with
# non-directory".  Remove the symlink from staging; the terminfo data lives
# in /usr/share/terminfo and the system's /usr/lib/terminfo is left untouched.
if [ -L "$DESTDIR/usr/lib/terminfo" ]; then
    rm "$DESTDIR/usr/lib/terminfo"
fi

# Create symlinks for compatibility
for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so "$DESTDIR/usr/lib/lib${lib}.so"
    ln -sfv ${lib}w.pc    "$DESTDIR/usr/lib/pkgconfig/${lib}.pc"
done

ln -sfv libncursesw.so "$DESTDIR/usr/lib/libcurses.so"

# Install documentation
mkdir -pv "$DESTDIR/usr/share/doc/ncurses-6.5"
cp -v -R doc/* "$DESTDIR/usr/share/doc/ncurses-6.5"
