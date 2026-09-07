#!/usr/bin/env bash
# Installs the newest FFmpeg package available for this AlmaLinux release.
# Supports AlmaLinux 8 and 9+ via RPM Fusion.
set -Eeuo pipefail

if (( EUID != 0 )); then
  exec sudo --preserve-env=PATH bash "$0" "$@"
fi

if [[ ! -f /etc/almalinux-release && ! -f /etc/redhat-release ]]; then
  echo "Error: this installer is intended for AlmaLinux/RHEL-compatible systems." >&2
  exit 1
fi

RHEL_MAJOR="$(rpm -E '%{?rhel}')"
if [[ ! "$RHEL_MAJOR" =~ ^(8|9|10)$ ]]; then
  echo "Error: unsupported or undetected Enterprise Linux major version: ${RHEL_MAJOR:-unknown}" >&2
  exit 1
fi

dnf -y install dnf-plugins-core curl ca-certificates

# RPM Fusion requires EPEL on Enterprise Linux. EL 8 calls CRB 'powertools'.
if [[ "$RHEL_MAJOR" -eq 8 ]]; then
  dnf config-manager --set-enabled powertools || true
else
  dnf config-manager --set-enabled crb || true
fi

dnf -y install "https://dl.fedoraproject.org/pub/epel/epel-release-latest-${RHEL_MAJOR}.noarch.rpm"
dnf -y install "https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-${RHEL_MAJOR}.noarch.rpm"

dnf -y makecache --refresh

# If a limited distribution ffmpeg-free package is present, replace it with RPM Fusion's full build.
if rpm -q ffmpeg-free >/dev/null 2>&1; then
  dnf -y swap ffmpeg-free ffmpeg --allowerasing
else
  dnf -y install ffmpeg
fi

dnf -y upgrade ffmpeg 'ffmpeg-*' --refresh

printf '\nInstalled FFmpeg version:\n'
ffmpeg -hide_banner -version | head -n 1

