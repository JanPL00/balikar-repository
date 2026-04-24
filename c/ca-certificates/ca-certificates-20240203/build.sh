#!/bin/bash
set -e

# ca-certificates 20240203 Build Script
# Upstream source: Debian ca-certificates package
# Based on Mozilla CA certificate bundle

make

make DESTDIR="${DESTDIR}" install

# Ensure the ca-certificates.crt bundle exists
if [ -f "${DESTDIR}/etc/ssl/certs/ca-certificates.crt" ]; then
    chmod 644 "${DESTDIR}/etc/ssl/certs/ca-certificates.crt"
fi
