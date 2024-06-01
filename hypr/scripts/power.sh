#!/bin/bash
#  ____                        
# |  _ \ _____      _____ _ __ 
# | |_) / _ \ \ /\ / / _ \ '__|
# |  __/ (_) \ V  V /  __/ |   
# |_|   \___/ \_/\_/ \___|_|   
#                              

if [[ "$1" == "exit" ]]; then
    echo ":: Exit"
    sleep 0.5
    killall -9 Hyprland sleep 2
fi

if [[ "$1" == "lock" ]]; then
    echo ":: Lock"
    sleep 0.5
    hyprlock    
fi

if [[ "$1" == "reboot" ]]; then
    echo ":: Reboot"
    sleep 0.5
    systemctl reboot
fi

if [[ "$1" == "shutdown" ]]; then
    echo ":: Shutdown"
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
    sleep 1; 
    systemctl hibernate    
fi