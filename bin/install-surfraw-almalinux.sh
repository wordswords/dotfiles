#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly CLONE_DIR="/tmp/surfraw"

sudo rm -rf "${CLONE_DIR}"
sudo dnf install git make perl
git clone https://gitlab.com/surfraw/Surfraw.git "${CLONE_DIR}"
cd "${CLONE_DIR}"
./prebuild
./configure --prefix=/usr/local
make
sudo make install
cd -
