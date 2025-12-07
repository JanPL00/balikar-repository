#!/bin/bash
# Simple install script for iana-etc
# Just copy the files to /etc

# Create target directory
mkdir -p "${DESTDIR}/etc"

install -vm644 services "${DESTDIR}/etc/services"
install -vm644 protocols "${DESTDIR}/etc/protocols"
