#!/bin/bash

CURRENT_THEME=$(cat ~/.config/ml4w/settings/system-theme.sh)

# Waybar
WAYBAR_LIGHT_THEME="/ml4w-modern;/ml4w-modern/light"
WAYBAR_DARK_THEME="/ml4w-modern;/ml4w-modern/mixed"

# GTK


# Switch system theme
if [ "${CURRENT_THEME}" == "dark" ]; then
    # Waybar
    echo "$WAYBAR_LIGHT_THEME" > ~/.config/ml4w/settings/waybar-theme.sh
    echo "light" > ~/.config/ml4w/settings/system-theme.sh
    ~/.config/waybar/launch.sh

    # GTK
    sed -i 's/color-scheme=prefer-dark/color-scheme=prefer-light/g' ~/.local/share/nwg-look/gsettings
    nwg-look -a

    CURRENT_THEME=$(cat ~/.config/ml4w/settings/system-theme.sh)
    notify-send "Theme changed to $CURRENT_THEME"
elif [ "${CURRENT_THEME}" == "light" ]; then
    # Waybar
    echo "$WAYBAR_DARK_THEME" > ~/.config/ml4w/settings/waybar-theme.sh
    echo "dark" > ~/.config/ml4w/settings/system-theme.sh
    ~/.config/waybar/launch.sh

    # GTK
    sed -i 's/color-scheme=prefer-light/color-scheme=prefer-dark/g' ~/.local/share/nwg-look/gsettings
    nwg-look -a

    CURRENT_THEME=$(cat ~/.config/ml4w/settings/system-theme.sh)
    notify-send "Theme changed to $CURRENT_THEME"
fi
    
