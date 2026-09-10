#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly CLONE_DIR="/tmp/surfraw"
sudo dnf install git make perl
sudo rm -rf "${CLONE_DIR}"
git clone https://gitlab.com/surfraw/Surfraw.git "${CLONE_DIR}"
cd "${CLONE_DIR}"
./prebuild
make
sudo make install
cd -
