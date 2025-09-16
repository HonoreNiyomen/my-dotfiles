#!/usr/bin/env bash
# gammastep-toggle.sh
# Usage:
#   gammastep-toggle.sh toggle      # toggle on/off (default params)
#   gammastep-toggle.sh on [T]      # start with optional temp (e.g. 6500:4000 or 5000)
#   gammastep-toggle.sh off         # stop
#   gammastep-toggle.sh set T       # stop + start with T
#   gammastep-toggle.sh status      # show running/stopped via notify-send

set -euo pipefail

PROG="gammastep"
USER_ID="${USER:-$(whoami)}"

# defaults (from your history)
DEFAULT_LOC="-l -15.4:28.3"
DEFAULT_TEMP="-t 3500:3000"

notify() {
  # small wrapper: change urgency or icon as you like
  notify-send "gammastep" "$1"
}

is_running() {
  # pgrep -u for only this user (handles multi-user systems)
  pgrep -u "$USER_ID" -x "$PROG" >/dev/null 2>&1
}

start_gammastep() {
  local tflag="${1:-$DEFAULT_TEMP}"
  local lflag="${2:-$DEFAULT_LOC}"
  # ensure gammastep exists
  if ! command -v "$PROG" >/dev/null 2>&1; then
    notify "cannot start: $PROG not found"
    return 1
  fi
  # Launch detached so it keeps running after sway's exec returns
  setsid "$PROG" $lflag $tflag >/dev/null 2>&1 &
  sleep 0.15
  notify "enabled — $tflag"
}

stop_gammastep() {
  if is_running; then
    pkill -u "$USER_ID" -x "$PROG" || true
    sleep 0.05
    notify "disabled"
  else
    notify "not running"
  fi
}

case "${1:-toggle}" in
toggle)
  if is_running; then
    stop_gammastep
  else
    start_gammastep
  fi
  ;;
on)
  # optional second arg: temp (6500:4000 or 5000)
  if [ -n "${2:-}" ]; then
    arg="$2"
    if [[ "$arg" == *:* ]]; then
      tflag="-t $arg"
    else
      tflag="-t $arg:$arg"
    fi
  else
    tflag="$DEFAULT_TEMP"
  fi
  start_gammastep "$tflag"
  ;;
off)
  stop_gammastep
  ;;
set)
  if [ -z "${2:-}" ]; then
    echo "Usage: $0 set <temp> (e.g. 6500:4000 or 5000)"
    exit 2
  fi
  tmp="$2"
  if [[ "$tmp" == *:* ]]; then
    tflag="-t $tmp"
  else
    tflag="-t $tmp:$tmp"
  fi
  stop_gammastep
  start_gammastep "$tflag"
  ;;
status)
  if is_running; then
    pid=$(pgrep -u "$USER_ID" -x "$PROG" | head -n1)
    notify "running (pid $pid)"
  else
    notify "stopped"
  fi
  ;;
*)
  echo "Usage: $0 [toggle|on [temp]|off|set <temp>|status]"
  exit 2
  ;;
esac
