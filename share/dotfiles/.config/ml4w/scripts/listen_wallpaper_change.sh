#!/bin/bash

CURRENT_WALLPAPER_PATH=$HOME/hyprland-setup/dotfiles/dot_config/ml4w/cache/current_wallpaper
CONFIG_FILE=$HOME/hyprland-setup/dotfiles/dot_config/waypaper/config.ini
LAST_WALLPAPER=""

get_current_wallpaper() {
    grep -oP '^wallpaper\s*=\s*\K.*' "$CONFIG_FILE"
}

LAST_WALLPAPER=$(get_current_wallpaper)

inotifywait -m -e modify "$CONFIG_FILE" | while read -r path event file; do
    CURRENT_WALLPAPER=$(get_current_wallpaper)

    if [[ "$CURRENT_WALLPAPER" != "$LAST_WALLPAPER" ]]; then
        LAST_WALLPAPER=$CURRENT_WALLPAPER
        echo "El wallpaper ha cambiado: $CURRENT_WALLPAPER"
        rm $CURRENT_WALLPAPER_PATH || true
        touch $CURRENT_WALLPAPER_PATH || true
        echo "$LAST_WALLPAPER" >> $CURRENT_WALLPAPER_PATH
        sed -i "s|~|$HOME|g" "$CURRENT_WALLPAPER_PATH"
    fi
    sleep 0.01
done
