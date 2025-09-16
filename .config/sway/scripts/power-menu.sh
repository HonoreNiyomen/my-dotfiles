#!/bin/bash

# Show power options using wofi in dmenu mode
chosen=$(echo -e "Shutdown\nReboot\nLog Out\nSuspend\nHibernate" | wofi --dmenu --prompt "Power Menu")

case $chosen in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Log\ Out)
        swaymsg exit
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
