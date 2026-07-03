#!/usr/bin/env bash

# Pipe the JSON stream directly through jq and awk, straight into rofi
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

    # Output: Line 1 (Keys), Line 2 (Description), followed by the Null separator
    printf "%s\n➔ %s\0", combo, desc
}' | rofi -dmenu -i -replace -p "Keybinds" -sep '\0' -eh 2 -config ~/.config/rofi/config-compact.rasi