#!/bin/bash

# Show power options using rofi
chosen=$(echo -e "Shutdown\nReboot\nLog Out\nSuspend\nHibernate" | wofi -dmenu -i -p "Power Menu")

case $chosen in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Log\ Out)
        i3-msg exit
        ;;
    Suspend)
        systemctl suspend
        ;;
    Hibernate)
        systemctl hibernate
        ;;
    *)
        exit 0
        ;;
esac
