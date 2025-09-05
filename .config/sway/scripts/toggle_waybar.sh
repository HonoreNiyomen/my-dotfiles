#!/usr/bin/env bash
# Toggle Waybar: start it if not running, or stop it if running.
# If a systemd --user unit named "waybar.service" exists, use that.
# Otherwise manage the waybar process directly.
#
# Install: chmod +x ~/.config/sway/scripts/toggle_waybar.sh
#
# Use from sway config like:
# bindsym $mod+b exec --no-startup-id ~/.config/sway/scripts/toggle_waybar.sh

set -euo pipefail

USER_NAME="$(id -un)"
WAYBAR_BIN="$(command -v waybar || true)"

# small helper to send user notification if notify-send exists
notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Waybar" "$1"
  fi
}

# 1) If there's a systemd --user unit called waybar.service, toggle it.
if command -v systemctl >/dev/null 2>&1; then
  if systemctl --user status waybar.service >/dev/null 2>&1; then
    if systemctl --user is-active --quiet waybar.service; then
      systemctl --user stop waybar.service
      notify "Stopped (systemd user unit)"
      exit 0
    else
      systemctl --user start waybar.service
      notify "Started (systemd user unit)"
      exit 0
    fi
  fi
fi

# 2) Fallback to process-level toggling (per-user)
# Check for any waybar processes belonging to this user
if pgrep -u "$USER_NAME" -x waybar >/dev/null 2>&1; then
  # kill them politely (SIGTERM), fallback to SIGKILL if needed
  pkill -u "$USER_NAME" -x waybar 2>/dev/null || true
  sleep 0.08
  # if still present, force kill
  if pgrep -u "$USER_NAME" -x waybar >/dev/null 2>&1; then
    pkill -9 -u "$USER_NAME" -x waybar 2>/dev/null || true
  fi
  notify "Waybar stopped"
  exit 0
else
  # start waybar
  if [ -z "$WAYBAR_BIN" ]; then
    notify "Waybar binary not found"
    echo "Error: waybar not installed or not in PATH" >&2
    exit 1
  fi

  # Start waybar detached so it survives the exec context from sway.
  # Redirect stdout/stderr to /dev/null (or to a log if you prefer).
  setsid "$WAYBAR_BIN" >/dev/null 2>&1 &
  disown
  # small delay to let it start
  sleep 0.12

  # confirm started
  if pgrep -u "$USER_NAME" -x waybar >/dev/null 2>&1; then
    notify "Waybar started"
    exit 0
  else
    notify "Failed to start Waybar"
    echo "Failed to launch waybar" >&2
    exit 1
  fi
fi
