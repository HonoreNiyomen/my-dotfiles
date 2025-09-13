#!/usr/bin/env bash

# 0) give user feedback while they wait
notify-send "Launching" "Bluetooth Manager..."

# 1) Start the applet if it isn't already
if ! pgrep -x blueman-applet > /dev/null; then
  # detach it so Waybar doesn't hang
  setsid blueman-applet >/dev/null 2>&1 &
  # give it a moment to register its DBus interfaces
  sleep 1
fi

# 2) Now open the manager window
blueman-manager
