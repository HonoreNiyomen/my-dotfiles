#!/usr/bin/env bash
# ~/.config/waybar/scripts/toggle-power-profile.sh
# No-arg -> prints a short status string for Waybar (stdout)
# Arg "t" -> toggle to next profile and print the new profile (and notify)

set -euo pipefail

POWERPROFILESCTL=$(command -v powerprofilesctl || true)
NOTIFY_SEND=$(command -v notify-send || true)

if [[ -z "$POWERPROFILESCTL" ]]; then
  echo "unknown"
  exit 1
fi

profiles=(performance balanced power-saver)

current=$($POWERPROFILESCTL get 2>/dev/null || echo "unknown")

# choose an icon/string to show in waybar for each profile
# change these to any glyphs/text you prefer
case "$current" in
"performance") ICON="  " ;;
"balanced") ICON="  " ;;
"power-saver") ICON="  " ;;
*) ICON=" ❔ " ;;
esac

if [[ "${1:-}" == "t" ]]; then
  # find next index and set it
  for i in "${!profiles[@]}"; do
    if [[ "${profiles[$i]}" == "$current" ]]; then
      next=$(((i + 1) % ${#profiles[@]}))
      new_profile=${profiles[$next]}
      # try to set it (silence non-fatal errors)
      $POWERPROFILESCTL set "$new_profile" >/dev/null 2>&1 || true
      # notify
      # if [[ -n "$NOTIFY_SEND" ]]; then
      #   $NOTIFY_SEND "$ICON  Power Profile" "Switched to $new_profile"
      # fi
      # print new status for Waybar immediately
      case "$new_profile" in
      "performance") echo "  " ;;
      "balanced") echo "  " ;;
      "power-saver") echo "  " ;;
      *) echo " ❔ " ;;
      esac
      exit 0
    fi
  done

  # if current not found in list, just set balanced
  $POWERPROFILESCTL set balanced >/dev/null 2>&1 || true
  # if [[ -n "$NOTIFY_SEND" ]]; then
  #   $NOTIFY_SEND "  Power Profile" "Switched to balanced"
  # fi
  echo "  "
  exit 0
else
  # no arg: print current status for Waybar
  echo "$ICON"

  exit 0
fi
