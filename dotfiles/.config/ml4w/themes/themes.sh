#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$(cat $HOME/.config/ml4w/settings/launcher)

# -----------------------------------------------------
# Themes
# -----------------------------------------------------
if command -v walker > /dev/null 2>&1; then
    # Walker installed
    THEME_OPTIONS=$(find "$SCRIPT_DIR" -maxdepth 1 -mindepth 1 -type d | awk -F/ '{ print $NF }')
else
    # Walker not installed
    THEME_OPTIONS=$(find "$SCRIPT_DIR" -maxdepth 1 -mindepth 1 -type d -not -name "*walker*" | awk -F/ '{ print $NF }')
fi
# -----------------------------------------------------
# Start Launcher
# -----------------------------------------------------

if [ "$launcher" == "walker" ]; then
    selected_theme=$($HOME/.config/walker/launch.sh -d -N -H -p "Search Theme" <<<"$THEME_OPTIONS")
else
    selected_theme=$(rofi -dmenu -i -markup -eh 2 -replace -p "Keybinds" -config ~/.config/rofi/config-compact.rasi <<<"$THEME_OPTIONS")
fi

# -----------------------------------------------------
# Source selected theme
# -----------------------------------------------------

source $HOME/.config/ml4w/themes/$selected_theme/theme.sh