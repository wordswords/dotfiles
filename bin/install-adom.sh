#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Install ADOM - Ancient Domains of Mystery - my 'desert island' game
# For desert island situations.
# ADOM_VERSION can be set via the environment (exported by deploy.sh).
#
ADOM_VERSION="${ADOM_VERSION:-3.3.3}"
ARCHIVE="adom_linux_ubuntu_64_${ADOM_VERSION}.tar.gz"

sudo dnf install -y ncurses-libs
sudo dnf config-manager --set-enabled crb
sudo dnf install ncurses-compat-libs -y
wget "https://www.adom.de/home/download/current/adom_linux_ubuntu_64_${ADOM_VERSION}.tar.gz"
tar xzf "adom_linux_ubuntu_64_${ADOM_VERSION}.tar.gz"
cp ./adom*/adom ~/bin
rm -rf ./adom*
wget "https://www.adom.de/home/download/current/${ARCHIVE}"
tar xzf "${ARCHIVE}"

# The archive extracts into a versioned adom*/ directory.
sudo install -m 755 ./adom*/adom "${HOME}/bin/adom"
find . -maxdepth 1 -type d -name 'adom*' -exec rm -rf {} +
rm -f "${ARCHIVE}"

