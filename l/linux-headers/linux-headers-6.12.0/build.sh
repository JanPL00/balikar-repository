#!/bin/bash
set -e

# linux-headers 6.12.0 Build Script
# Install sanitized kernel headers (Based on LFS)

make mrproper

make headers

# Remove non-header files
find usr/include -type f ! -name '*.h' -delete

cp -rv usr/include "${DESTDIR}/usr/"
