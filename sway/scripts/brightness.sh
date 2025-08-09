#!/bin/bash

# Adjust brightness using brightnessctl and show a replaceable notification

# Adjust the brightness
brightnessctl set "$1"

# Get current brightness percentage
current_brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
brightness_percent=$((current_brightness * 100 / max_brightness))

# Send or update the notification
notify-send -u low -h int:value:"$brightness_percent" -h string:x-canonical-private-synchronous:brightness "Brightness: ${brightness_percent}%"
