#!/usr/bin/env bash

case "$1" in
  --toggle)
    # If soft-blocked, unblock; otherwise block
    if /usr/sbin/rfkill list bluetooth | grep -q "Soft blocked: yes"; then
      /usr/sbin/rfkill unblock bluetooth
      notify-send "Bluetooth" "󰂲 Powered On"
    else
      /usr/sbin/rfkill block bluetooth
      notify-send "Bluetooth" " Powered Off"
    fi
    ;;
  *)
    # Report status based on rfkill
    if /usr/sbin/rfkill list bluetooth | grep -q "Soft blocked: yes"; then
      echo " 󰂲 "
    else
      echo "  "
    fi
    ;;
esac
