#!/bin/bash

# Adjust volume using pamixer and show a replaceable notification

# Check if the argument is to increase or decrease volume
if [[ "$1" == "+"* ]]; then
    pamixer --allow-boost --increase "${1#+}"
elif [[ "$1" == "-"* ]]; then
    pamixer --allow-boost --decrease "${1#-}"
fi

# Get the current volume percentage
volume=$(pamixer --get-volume)

# Check if muted
is_muted=$(pamixer --get-mute)
if [[ "$is_muted" == "true" ]]; then
    notify-send -u low -h string:x-canonical-private-synchronous:volume "Volume: Muted"
else
    notify-send -u low -h int:value:"$volume" -h string:x-canonical-private-synchronous:volume "Volume: $volume%"
fi
