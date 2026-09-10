#!/usr/bin/env bash
#
# install-ha-kiosk.sh — cage-based Firefox kiosk (replaces GDM/GNOME Kiosk approach)
#
# Run as root: sudo bash install-ha-kiosk.sh

set -Eeuo pipefail

KIOSK_USER="ha"
KIOSK_PASSWORD="ha"
KIOSK_URL="https://example.org"   # <-- CHANGE THIS

if [[ "${EUID}" -ne 0 ]]; then
    echo "Run as root." >&2; exit 1
fi

echo "==> Installing packages..."
dnf install -y epel-release
dnf install -y cage firefox

echo "==> Creating kiosk user..."
if ! id "${KIOSK_USER}" &>/dev/null; then
    useradd --create-home --shell /bin/bash "${KIOSK_USER}"
fi
echo "${KIOSK_USER}:${KIOSK_PASSWORD}" | chpasswd
gpasswd -d "${KIOSK_USER}" wheel 2>/dev/null || true

echo "==> Setting graphical boot target..."
systemctl set-default graphical.target

echo "==> Disabling GDM (not used by this approach)..."
systemctl disable --now gdm.service 2>/dev/null || true

echo "==> Creating kiosk launcher..."
install -d -m 0755 "/home/${KIOSK_USER}/.local/bin"
cat >"/home/${KIOSK_USER}/.local/bin/kiosk-firefox.sh" <<EOF
#!/usr/bin/env bash
exec /usr/bin/firefox --kiosk --no-remote "${KIOSK_URL}"
EOF
chmod 0755 "/home/${KIOSK_USER}/.local/bin/kiosk-firefox.sh"
chown -R "${KIOSK_USER}:${KIOSK_USER}" "/home/${KIOSK_USER}/.local"

echo "==> Creating systemd autologin on tty1..."
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat >/etc/systemd/system/getty@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin ${KIOSK_USER} --noclear %I \$TERM
EOF

echo "==> Auto-starting cage+Firefox on tty1 login..."
cat >>"/home/${KIOSK_USER}/.bash_profile" <<'EOF'

if [[ -z "${DISPLAY:-}" ]] && [[ "$(tty)" == "/dev/tty1" ]]; then
    exec cage -- /home/ha/.local/bin/kiosk-firefox.sh
fi
EOF
chown "${KIOSK_USER}:${KIOSK_USER}" "/home/${KIOSK_USER}/.bash_profile"

systemctl daemon-reload
systemctl restart getty@tty1.service

echo "Done. Reboot to test: sudo systemctl reboot"
