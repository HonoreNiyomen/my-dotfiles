#!/usr/bin/env bash
# ~/.config/sway/scripts/lock_screen.sh
# Capture fullscreen, blur it, and lock with swaylock using that image.

set -euo pipefail

# files (unique per user)
USER_ID=$(id -u)
TMPSHOT="/tmp/swaylock-shot-${USER_ID}.png"
TMPBLUR="/tmp/swaylock-blur-${USER_ID}.png"

# cleanup function (tries to remove temp files, but doesn't error if can't)
_cleanup() {
  rm -f -- "$TMPSHOT" "$TMPBLUR" || true
}
trap _cleanup EXIT

# required commands
command -v grim >/dev/null 2>&1 || {
  echo "grim not found — install 'grim'"
  exit 1
}
command -v convert >/dev/null 2>&1 || {
  echo "imagemagick (convert) not found — install 'imagemagick'"
  exit 1
}
command -v swaylock >/dev/null 2>&1 || {
  echo "swaylock not found — install 'swaylock'"
  exit 1
}

# 1) Capture fullscreen
grim "$TMPSHOT"

# 2) Create a nice blur. Strategy: downscale -> blur -> upscale (faster and nicer)
DOWNSCALE_PERCENT="10%" # smaller -> faster and stronger blur
BLUR_RADIUS="0x3"       # increase number to blur more
UPSCALE_PERCENT="1000%" # bring back to original size

# Convert command
convert "$TMPSHOT" -resize "$DOWNSCALE_PERCENT" -blur "$BLUR_RADIUS" -resize "$UPSCALE_PERCENT" "$TMPBLUR"

# 3) Optional: overlay a dark tint for readability
# convert "$TMPBLUR" -fill "rgba(0,0,0,0.25)" -draw "rectangle 0,0 10000,10000" "$TMPBLUR"

# 4) Lock with swaylock using the blurred image
swaylock -i "$TMPBLUR"

exit 0
