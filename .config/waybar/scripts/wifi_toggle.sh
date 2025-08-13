#!/usr/bin/env bash

# Query current Wi-Fi state
state=$(nmcli radio wifi)

if [[ "$state" == "enabled" ]]; then
  nmcli radio wifi off
  notify-send "📡 Wi-Fi" "Disabled"
else
  nmcli radio wifi on
  notify-send "📡 Wi-Fi" "Enabled"
fi
