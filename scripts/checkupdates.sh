#!/bin/bash
#  _   _           _       _             
# | | | |_ __   __| | __ _| |_ ___  ___  
# | | | | '_ \ / _` |/ _` | __/ _ \/ __| 
# | |_| | |_) | (_| | (_| | ||  __/\__ \ 
#  \___/| .__/ \__,_|\__,_|\__\___||___/ 
#       |_|                              
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

format() {
    if [ "$1" -eq 0 ]; then
        echo '-'
    else
        echo "$1"
    fi
}

if ! updates_arch="$(pacman -Qm >/dev/null | wc -l)"; then
    updates_arch=0
fi

if ! updates_aur="$(yay -Qum 2>/dev/null | wc -l)"; then
    updates_aur=0
fi

echo "($(format $updates_arch)/$(format $updates_aur))"
