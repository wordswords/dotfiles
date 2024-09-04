#!/bin/bash

set -x
set -e

if [ $# -eq 0 ]; then
    >&2 echo "Usage: $0 <Vim verison on https://mirrorservice.org/pub/vim/unix/>"
    exit 1
fi
VERSION=$1

TMP_DIR=$(mktemp -d)
cd "${TMP_DIR}"
wget https://github.com/vim/vim/archive/refs/tags/v$1.tar.gz
tar zxf v*gz
rm ./*tar | true
rm ./*bz2* | true
cd ./vim*
make clean dist clean
./configure --enable-python3interp=yes --with-python3-command=/opt/homebrew/bin/python3.9 --with-python3-config-dir="$(/opt/homebrew/bin/python3.9-config --configdir)"
make -j
sudo make install
cd ..
rm -rf "${TMP_DIR}"

