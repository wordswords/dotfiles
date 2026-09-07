#!/usr/bin/env bash
set -Eeuo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run this script as root, for example: sudo bash $0" >&2
  exit 1
fi

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  if [[ ${ID:-} != "almalinux" || ${VERSION_ID%%.*} != "10" ]]; then
    echo "Warning: this script is intended for AlmaLinux 10; detected: ${PRETTY_NAME:-unknown}" >&2
  fi
fi

if ! command -v dnf >/dev/null 2>&1; then
  echo "dnf was not found; this does not appear to be a DNF-based system." >&2
  exit 1
fi

echo "Enabling repositories and installing snapd..."
if command -v crb >/dev/null 2>&1; then
  crb enable || echo "Warning: could not enable CRB; continuing." >&2
fi

dnf install -y epel-release
dnf upgrade -y
dnf install -y kernel-modules snapd

echo "Enabling the snapd socket..."
systemctl enable --now snapd.socket

echo "Enabling classic-confinement support..."
ln -sfn /var/lib/snapd/snap /snap

echo "Verifying installation..."
systemctl is-active --quiet snapd.socket
snap --version

echo
echo "Snapd installation is complete. Log out and back in, or reboot, before using classic snaps."
echo "Optional test after re-login/reboot: sudo snap install hello-world && hello-world"

