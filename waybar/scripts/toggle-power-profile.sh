#!/usr/bin/env bash

# Uses powerprofilesctl (part of power-profiles-daemon)
# to switch between 'performance' and 'power-saver'

current=$(powerprofilesctl get)  # e.g. "balanced", "power-saver", "performance"

if [[ "$current" == "power-saver" ]]; then
  powerprofilesctl set performance
  notify-send "🔋 Power Profile" "Switched to Performance Mode"
else
  powerprofilesctl set power-saver
  notify-send "🔋 Power Profile" "Switched to Power-Saver Mode"
fi
