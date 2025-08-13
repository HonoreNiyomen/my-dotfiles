#!/bin/bash

case "$1" in
    --toggle)
        # Toggle Bluetooth on or off
        bluetoothctl show | grep -q "Powered: yes" && bluetoothctl power off || bluetoothctl power on
        ;;
    *)
        # Check Bluetooth status
        bluetooth_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
        if [[ "$bluetooth_status" == "yes" ]]; then
            echo " On"
        else
            echo " Off"
        fi
        ;;
esac

