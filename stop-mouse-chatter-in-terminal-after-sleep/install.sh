#!/bin/bash
# Installs the fix-terminal-mouse system-sleep hook:
#   /usr/lib/systemd/system-sleep/fix-terminal-mouse
# systemd-sleep calls every executable in /usr/lib/systemd/system-sleep/
# on every suspend/hibernate cycle with "pre"/"post" + the sleep type;
# the hook acts on "post" (resume) and disables mouse tracking on all
# live ptys.
#
# NB: /etc/systemd/system-sleep/ is NOT scanned by modern systemd
# (it's a relic of old blog posts) - the hook must live in /usr/lib.
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
TARGET_DIR=/usr/lib/systemd/system-sleep
TARGET="$TARGET_DIR/fix-terminal-mouse"
LEGACY_DIR=/etc/systemd/system-sleep

# Clean up a hook installed by an older version of this script, which
# targeted the /etc path that systemd no longer scans. Only removes our
# file (and the dir if it ends up empty) - never touches other hooks.
if [ -e "$LEGACY_DIR/fix-terminal-mouse" ]; then
    rm -f "$LEGACY_DIR/fix-terminal-mouse"
    rmdir "$LEGACY_DIR" 2>/dev/null || true
    echo "removed stale hook from $LEGACY_DIR (systemd does not scan it)"
fi

if [ "${1:-}" = "uninstall" ]; then
    rm -f "$TARGET"
    echo "uninstalled"
    exit 0
fi

mkdir -p "$TARGET_DIR"
install -m 0755 "$DIR/fix-terminal-mouse" "$TARGET"

echo "installed: $TARGET"
echo
echo "it fires on its own after every resume - no enable, no reload needed."
echo "test manually:"
echo "  sudo $TARGET post suspend"
