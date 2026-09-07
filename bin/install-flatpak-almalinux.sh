#!/usr/bin/env bash
# Install Flatpak on AlmaLinux 10.
# Run as root, or with: sudo bash install_flatpak_almalinux10.sh

set -Eeuo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Please run this script as root (for example: sudo bash $0)." >&2
  exit 1
fi

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
else
  echo "Cannot identify the operating system: /etc/os-release is missing." >&2
  exit 1
fi

if [[ ${ID:-} != "almalinux" || ${VERSION_ID%%.*} != "10" ]]; then
  echo "Warning: this script is intended for AlmaLinux 10; detected ${PRETTY_NAME:-unknown OS}." >&2
fi

DNF=(dnf -y)
if command -v dnf5 >/dev/null 2>&1; then
  DNF=(dnf5 -y)
fi

echo "Refreshing package metadata..."
"${DNF[@]}" makecache

echo "Installing Flatpak..."
"${DNF[@]}" install flatpak

echo "Adding the Flathub remote (if not already configured)..."
flatpak remote-add --if-not-exists --system flathub \
  https://dl.flathub.org/repo/flathub.flatpakrepo

echo
flatpak --version
flatpak remotes --system

echo
echo "Flatpak is installed and Flathub is configured."
echo "Example: flatpak install flathub org.mozilla.firefox"

