#!/bin/bash
set -e

# Python 3.12.7 — minimal interpreter build. Many stdlib modules (ssl,
# sqlite3, _tkinter, ...) require external libraries; we deliberately skip
# them so the package can be installed on a minimal Debian image. zlib is
# the only required balikar dep and is picked up from the active --root.
PREFIX_ROOT="${BALIKAR_ROOT:-/}"
DEPROOT="${PREFIX_ROOT%/}/usr"

export CPPFLAGS="-I${DEPROOT}/include ${CPPFLAGS}"
export LDFLAGS="-L${DEPROOT}/lib -Wl,-rpath,${DEPROOT}/lib ${LDFLAGS}"

# Upstream tarball directory is "Python-3.12.7" (capital P). balikar
# extracted into <build>/python3-3.12.7/, then we may need to enter the
# inner directory shipped inside the tarball.
if [ -d Python-3.12.7 ]; then
    cd Python-3.12.7
fi

./configure --prefix=/usr            \
            --enable-shared          \
            --without-ensurepip      \
            --with-system-expat=no   \
            --with-system-ffi=no     \
            --disable-test-modules

make -j$(nproc)

make DESTDIR="$DESTDIR" install
