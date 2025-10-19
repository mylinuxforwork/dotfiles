#!/usr/bin/env bash
#  _   _           _       _             
# | | | |_ __   __| | __ _| |_ ___  ___  
# | | | | '_ \ / _` |/ _` | __/ _ \/ __| 
# | |_| | |_) | (_| | (_| | ||  __/\__ \ 
#  \___/| .__/ \__,_|\__,_|\__\___||___/ 
#       |_|                              
#  

# Check if command exists
_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi
    echo 0
    return
}

script_name=$(basename "$0")

# Count the instances
instance_count=$(ps aux | grep -F "$script_name" | grep -v grep | grep -v $$ | wc -l)

if [ $instance_count -gt 1 ]; then
    sleep $instance_count
fi


# ----------------------------------------------------- 
# Define threshholds for color indicators
# ----------------------------------------------------- 

threshhold_green=0
threshhold_yellow=25
threshhold_red=100

# ----------------------------------------------------- 
# Check for updates
# ----------------------------------------------------- 

# Arch
if [[ $(_checkCommandExists "pacman") == 0 ]]; then

    check_lock_files() {
        local pacman_lock="/var/lib/pacman/db.lck"
        local checkup_lock="${TMPDIR:-/tmp}/checkup-db-${UID}/db.lck"

        while [ -f "$pacman_lock" ] || [ -f "$checkup_lock" ]; do
            sleep 1
        done
    }

    check_lock_files

    yay_installed="false"
    paru_installed="false"
    if [[ $(_checkCommandExists "yay") == 0 ]]; then
        yay_installed="true"
    fi
    if [[ $(_checkCommandExists "paru") == 0 ]]; then
        paru_installed="true"
    fi
    if [[ $yay_installed == "true" ]] && [[ $paru_installed == "false" ]]; then
        aur_helper="yay"
    elif [[ $yay_installed == "false" ]] && [[ $paru_installed == "true" ]]; then
        aur_helper="paru"
    else
        aur_helper="yay"
    fi
    updates_aur=$($aur_helper -Qum | wc -l)
    updates_pacman=$(checkupdates | wc -l)
    updates=$((updates_aur+updates_pacman))
    
# Fedora
elif [[ $(_checkCommandExists "dnf") == 0 ]]; then
    updates=$(dnf check-update -q | grep -c ^[a-z0-9])
# Others
else
    updates=0
fi

# ----------------------------------------------------- 
# Output in JSON format for Waybar Module custom-updates
# ----------------------------------------------------- 

css_class="green"

if [ "$updates" -gt $threshhold_yellow ]; then
    css_class="yellow"
fi

if [ "$updates" -gt $threshhold_red ]; then
    css_class="red"
fi
if [ "$updates" != 0 ]; then
    if [ "$updates" -gt $threshhold_green ]; then
        printf '{"text": "%s", "alt": "%s", "tooltip": "Click to update your system", "class": "%s"}' "$updates" "$updates" "$css_class"
    else
        printf '{"text": "0", "alt": "0", "tooltip": "No updates available", "class": "green"}'
    fi
fi
