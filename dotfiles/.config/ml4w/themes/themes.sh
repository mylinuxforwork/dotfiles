#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

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

selected_theme=$($HOME/.config/ml4w/scripts/ml4w-launcher dmenu -p "Search Theme" -l 5 --rofi-args "-no-show-icons -width 30" <<<"$THEME_OPTIONS")

# -----------------------------------------------------
# Source selected theme
# -----------------------------------------------------

source $HOME/.config/ml4w/themes/$selected_theme/theme.sh