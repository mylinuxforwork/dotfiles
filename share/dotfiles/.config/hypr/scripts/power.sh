#!/bin/bash
#  ____
# |  _ \ _____      _____ _ __
# | |_) / _ \ \ /\ / / _ \ '__|
# |  __/ (_) \ V  V /  __/ |
# |_|   \___/ \_/\_/ \___|_|
#

# Check if eww is open
FILE="$HOME/.cache/ml4w_sidebar"

if [[ "$1" == "exit" ]]; then
    echo ":: Exit"
    if [[ -f "$FILE" ]]; then
        rm $FILE
    fi
    sleep 0.5
    hyprctl dispatch exit
    sleep 2
fi

if [[ "$1" == "lock" ]]; then
    echo ":: Lock"
    sleep 0.5
    hyprlock
fi

if [[ "$1" == "reboot" ]]; then
    echo ":: Reboot"
    if [[ -f "$FILE" ]]; then
        rm $FILE
    fi
    sleep 0.5
    systemctl reboot
fi

if [[ "$1" == "shutdown" ]]; then
    echo ":: Shutdown"
    if [[ -f "$FILE" ]]; then
        rm $FILE
    fi
    sleep 0.5
    systemctl poweroff
fi

if [[ "$1" == "suspend" ]]; then
    echo ":: Suspend"
    sleep 0.5
    systemctl suspend
fi

if [[ "$1" == "hibernate" ]]; then
    echo ":: Hibernate"
    sleep 1
    systemctl hibernate
fi
