#!/usr/bin/env bash
# Adjust volume using pamixer and show a replaceable notification

PAMIXER=$(command -v pamixer || true)
PACTL=$(command -v pactl || true)
DUNSTIFY=$(command -v dunstify || true)
NOTIFY_SEND=$(command -v notify-send || true)
REPL_ID=9999  # replacement id for dunstify/notify-send (best-effort)

# Basic sanity
if [[ -z "$PAMIXER" ]]; then
  echo "pamixer not found" >&2
  exit 1
fi

# Use the available notification command
if [[ -n "$DUNSTIFY" ]]; then
  NOTIF_CMD="$DUNSTIFY"
  NOTIF_REPLACE="-r $REPL_ID"
else
  NOTIF_CMD="$NOTIFY_SEND"
  NOTIF_REPLACE=""   # notify-send may replace via the x-canonical hint
fi

# Get default sink (best-effort)
DEFAULT_SINK=$("$PACTL" info 2>/dev/null | awk -F': ' '/Default Sink/ {print $2; exit}' || true)

# Adjust volume (use $PAMIXER)
if [[ "$1" == "+"* ]]; then
    "$PAMIXER" --increase "${1#+}"
elif [[ "$1" == "-"* ]]; then
    "$PAMIXER" --decrease "${1#-}"
fi

# Choose device emoji based on sink name
case "$DEFAULT_SINK" in
  bluez_output.*)
    DEVICE_ICON="🎧"
    ;;
  alsa_output.pci-*)
    DEVICE_ICON="🔊"
    ;;
  alsa_output.usb-*)
    DEVICE_ICON="🎶"
    ;;
  *)
    DEVICE_ICON="🔈"
    ;;
esac

# Get current volume (integer) and mute state
volume=$("$PAMIXER" --get-volume 2>/dev/null || echo 0)
volnum=${volume%%.*}
is_muted=$("$PAMIXER" --get-mute 2>/dev/null || echo "false")

# Choose tray icon file depending on level
if (( volnum >= 66 )); then
  ICON=/usr/share/icons/Papirus/16x16@2x/actions/audio-volume-high.svg
elif (( volnum >= 34 )); then
  ICON=/usr/share/icons/Papirus/16x16@2x/actions/audio-volume-medium.svg
else
  ICON=/usr/share/icons/Papirus/16x16@2x/actions/audio-volume-low.svg
fi

# Create a padding of EM SPACES (U+2003) to nudge the emoji rightwards in the body.
# Adjust count if you need more/less padding.
PAD=$(printf '\u2003%.0s' {1..8})

# Build message
if [[ "$is_muted" == "true" ]]; then
  BODY="Muted${PAD}${DEVICE_ICON}"
else
  BODY="${volume}%${PAD}${DEVICE_ICON}"
fi

# Read current brightness percent
cur=$(brightnessctl get 2>/dev/null || echo "")
max=$(brightnessctl max 2>/dev/null || echo "")

if [ -n "$volnum" ]; then
  percent=$((volnum / 100 * 100))
else
  # If still empty, set to 0
  percent=${volume:-0}
fi

# Send notification (best-effort: dunstify -> notify-send)
# Keep x-canonical-private-synchronous hint so many daemons will replace.
if [[ -n "$DUNSTIFY" ]]; then

    $NOTIF_CMD -u low -h string:x-canonical-private-synchronous:volume -h int:value:0 -i "$ICON" "$BODY"
  else
    $NOTIF_CMD -u low -h string:x-canonical-private-synchronous:volume -h int:value:"$volume" -i "$ICON" "$BODY"
fi
