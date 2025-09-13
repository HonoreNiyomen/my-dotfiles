#!/usr/bin/env bash
set -euo pipefail

OUTDIR="$HOME/Pictures/Screenshots"
mkdir -p "$OUTDIR"
FILE="$OUTDIR/screenshot_$(date +%F_%H-%M-%S).png"

case "${1:-}" in
full)
  grim "$FILE"
  ;;
region)
  if command -v slurp >/dev/null 2>&1; then
    grim -g "$(slurp)" "$FILE"
  else
    grim "$FILE"
  fi
  ;;
*)
  notify-send "Screenshot" "Usage: screenshot.sh [full|region]"
  exit 1
  ;;
esac

# Copy to clipboard (if wl-copy exists)
if command -v wl-copy >/dev/null 2>&1; then
  wl-copy --type image/png <"$FILE"
  notify-send "Screenshot" "Saved and copied: $FILE"
else
  notify-send "Screenshot" "Saved: $FILE (install wl-clipboard to auto-copy)"
fi
