#!/bin/bash
# Installs the fix-terminal-mouse system-sleep hook:
#   /etc/systemd/system-sleep/fix-terminal-mouse
# systemd calls it automatically with "pre"/"post" + the sleep type on every
# suspend/hibernate cycle; the script acts on "post" (resume) and disables
# mouse tracking on all live ptys.
#
# Usage:
#   sudo ./install.sh            install
#   sudo ./install.sh uninstall  remove it again

set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "run as root (sudo ./install.sh)" >&2
    exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "${1:-}" = "uninstall" ]; then
    rm -f /etc/systemd/system-sleep/fix-terminal-mouse
    echo "uninstalled"
    exit 0
fi

install -m 0755 "$DIR/fix-terminal-mouse" /etc/systemd/system-sleep/fix-terminal-mouse

echo "installed: /etc/systemd/system-sleep/fix-terminal-mouse"
echo
echo "it fires on its own after every resume - no enable, no reload needed."
echo "test manually:"
echo "  sudo /etc/systemd/system-sleep/fix-terminal-mouse post suspend"
