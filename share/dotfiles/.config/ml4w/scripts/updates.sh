#!/bin/bash
#  _   _           _       _             
# | | | |_ __   __| | __ _| |_ ___  ___  
# | | | | '_ \ / _` |/ _` | __/ _ \/ __| 
# | |_| | |_) | (_| | (_| | ||  __/\__ \ 
#  \___/| .__/ \__,_|\__,_|\__\___||___/ 
#       |_|                              
#  

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
install_platform="$(cat ~/.config/ml4w/settings/platform.sh)"

# Check if platform is supported
case $install_platform in
    arch)
        aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"

        # ----------------------------------------------------- 
        # Calculate available updates
        # ----------------------------------------------------- 

        # flatpak remote-ls --updates

        # -----------------------------------------------------------------------------
        # Check for pacman or checkupdates-with-aur database lock and wait if necessary
        # -----------------------------------------------------------------------------
        check_lock_files() {
            local pacman_lock="/var/lib/pacman/db.lck"
            local checkup_lock="${TMPDIR:-/tmp}/checkup-db-${UID}/db.lck"

            while [ -f "$pacman_lock" ] || [ -f "$checkup_lock" ]; do
                sleep 1
            done
        }

        check_lock_files

        updates=$(checkupdates-with-aur | wc -l)
    ;;
    fedora)
        updates=$(dnf check-update -q | grep -c ^[a-z0-9])
    ;;
    *)
        updates=0
    ;;
esac

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

if [ "$updates" -gt $threshhold_green ]; then
    printf '{"text": "%s", "alt": "%s", "tooltip": "Click to update your system", "class": "%s"}' "$updates" "$updates" "$css_class"
else
    printf '{"text": "0", "alt": "0", "tooltip": "No updates available", "class": "green"}'
fi
