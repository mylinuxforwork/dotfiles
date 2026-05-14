#!/usr/bin/env bash
#    __            __   _         ___             
#   / /_____ __ __/ /  (_)__  ___/ (_)__  ___ ____
#  /  '_/ -_) // / _ \/ / _ \/ _  / / _ \/ _ `(_-<
# /_/\_\\__/\_, /_.__/_/_//_/\_,_/_/_//_/\_, /___/
#          /___/                        /___/     
# 

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$(cat $HOME/.config/ml4w/settings/launcher)
if [ "$launcher" == "walker" ]; then separator=":"; else separator=$'\r'; fi

keybinds=$(hyprctl binds -j | jq -r --arg SEPARATOR "$separator" '
    .[] 
    | (
        [
            (if (.modmask / 64 % 2 >= 1) then "SUPER" else empty end),
            (if (.modmask / 1 % 2 >= 1) then "SHIFT" else empty end),
            (if (.modmask / 4 % 2 >= 1) then "CTRL" else empty end),
            (if (.modmask / 8 % 2 >= 1) then "ALT" else empty end),
            (if (.modmask / 2 % 2 >= 1) then "CAPS" else empty end),
            .key
        ]
        | join(" + ") | ascii_upcase
    )
    + $SEPARATOR + "  " + .description
')

sleep 0.2

if [ "$launcher" == "walker" ]; then
    $HOME/.config/walker/launch.sh -d -N -H -p "Search Keybinds" <<<"$keybinds"
else
    rofi -dmenu -i -markup -eh 2 -replace -p "Keybinds" -config ~/.config/rofi/config-compact.rasi <<<"$keybinds"
fi
