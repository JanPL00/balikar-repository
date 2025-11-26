#!/bin/bash
set -e

# Build
make

# Install
make DESTDIR=$DESTDIR install
