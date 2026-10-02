#!/usr/bin/env bash

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$($HOME/.config/ml4w/scripts/ml4w-launcher which)

# Use Walker (one entry per line)
_show_walker() {
    awk -F '\t' '{ printf "%s  ➔ %s\n", $1, $2 }' | $HOME/.config/ml4w/scripts/ml4w-launcher dmenu -p "Keybinds"
}

# Use Rofi (two-line entries separated by null)
_show_rofi() {
    awk -F '\t' '{ printf "%s\n➔ %s\0", $1, $2 }' | $HOME/.config/ml4w/scripts/ml4w-launcher dmenu -p "Keybinds" -c ~/.config/rofi/config-compact.rasi --rofi-args "-sep \\0 -eh 2"
}

# Pipe the JSON stream through jq and awk into the configured launcher
hyprctl binds -j | jq -c '.[] | select(.description != "")' | awk '
BEGIN {
    # Define modifier bits based on libxkbcommon
    mod_map[64] = "SUPER"
    mod_map[8]  = "ALT"
    mod_map[4]  = "CTRL"
    mod_map[1]  = "SHIFT"
}
{
    # Extract values from jq JSON string
    match($0, /"modmask":([0-9]+)/, m)
    modmask = m[1]
    
    match($0, /"key":"([^"]+)"/, k)
    key = toupper(k[1])
    
    match($0, /"description":"([^"]+)"/, d)
    desc = d[1]

    # Reconstruct modifier names from mask
    mods = ""
    for (bit in mod_map) {
        if (and(modmask, bit)) {
            mods = (mods == "" ? mod_map[bit] : mods " + " mod_map[bit])
        }
    }

    # Format the key combination string
    if (mods != "" && key != "") {
        combo = mods " + " key
    } else {
        combo = (mods != "" ? mods : key)
    }

    # Output: Keys and Description separated by a tab
    printf "%s\t%s\n", combo, desc
}' | if [ "$launcher" == "walker" ]; then _show_walker; else _show_rofi; fi