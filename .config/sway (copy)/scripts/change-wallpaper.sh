#!/bin/bash

# Default directory to open
WALLPAPER_DIR="$HOME/Pictures"

# Open Zenity file chooser
FILE=$(zenity --file-selection \
  --title="Choose a Wallpaper" \
  --filename="$WALLPAPER_DIR/" \
  --file-filter="Images | *.png *.jpg *.jpeg *.bmp *.svg")

# If user picked a file
if [[ -n "$FILE" ]]; then
  # save Wallpaper
  sed -i "1s|.*|$FILE|" "$HOME/.config/sway/current_wallpaper.txt"

  # Kill old swaybg so new one replaces it
  pkill swaybg 2>/dev/null

  # Set background with swaybg
  swaybg -i "$FILE" -m fill &
fi
