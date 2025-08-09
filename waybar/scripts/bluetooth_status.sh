#!/usr/bin/env bash

case "$1" in
  --toggle)
    # If soft-blocked, unblock; otherwise block
    if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
      rfkill unblock bluetooth
      notify-send "Bluetooth" "Powered On"
    else
      rfkill block bluetooth
      notify-send "Bluetooth" "Powered Off"
    fi
    ;;
  *)
    # Report status based on rfkill
    if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
      echo "BT Off"
    else
      echo "BT On"
    fi
    ;;
esac
