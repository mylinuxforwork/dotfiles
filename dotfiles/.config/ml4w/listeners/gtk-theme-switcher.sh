#!/bin/bash

# This script monitors changes to the GTK settings.ini file
# and automatically switches the 'matugen' theme between light and dark
# based on the 'gtk-application-prefer-dark-theme' setting.

# Path to the GTK settings file
SETTINGS_FILE="$HOME/.config/gtk-4.0/settings.ini"

# Ensure inotify-tools is installed
if ! command -v inotifywait &> /dev/null
then
    echo "Error: inotifywait is not installed."
    echo "Please install inotify-tools (e.g., sudo apt install inotify-tools on Debian/Ubuntu)"
    exit 1
fi

echo "Monitoring $SETTINGS_FILE for changes..."
echo "Press Ctrl+C to stop."

# Function to apply the theme based on the current settings
apply_theme() {
    # Check if the settings file exists
    if [ ! -f "$SETTINGS_FILE" ]; then
        echo "Error: $SETTINGS_FILE not found. Please ensure the file exists."
        return 1
    fi

    # Extract the value of gtk-application-prefer-dark-theme
    # We use grep to find the line and awk to get the value after the '='
    THEME_PREF=$(grep -E '^gtk-application-prefer-dark-theme=' "$SETTINGS_FILE" | awk -F'=' '{print $2}')

    if [ -z "$THEME_PREF" ]; then
        echo "Warning: 'gtk-application-prefer-dark-theme' setting not found in $SETTINGS_FILE. Skipping theme application."
        return 0
    fi

    if [ "$THEME_PREF" -eq 1 ]; then
        echo "Detected dark theme preference (gtk-application-prefer-dark-theme=1). Applying dark matugen theme..."
        $HOME/.local/bin/matugen image $(cat ~/.cache/ml4w/hyprland-dotfiles/current_wallpaper)
        bash $HOME/.config/nwg-dock-hyprland/launch.sh &
        bash $HOME/.config/waybar/launch.sh &
    elif [ "$THEME_PREF" -eq 0 ]; then
        echo "Detected light theme preference (gtk-application-prefer-dark-theme=0). Applying light matugen theme..."
        $HOME/.local/bin/matugen image $(cat ~/.cache/ml4w/hyprland-dotfiles/current_wallpaper) -m "light"
        bash $HOME/.config/nwg-dock-hyprland/launch.sh &
        bash $HOME/.config/waybar/launch.sh &
    else
        echo "Warning: Unexpected value for gtk-application-prefer-dark-theme: $THEME_PREF. Expected 0 or 1. Skipping theme application."
    fi
}

# Loop indefinitely, waiting for file modifications
# -m: monitor for modify events
# -q: quiet mode, only output events
while inotifywait -q -e modify "$SETTINGS_FILE"; do
    echo "Change detected in $SETTINGS_FILE. Re-applying theme..."
    apply_theme
done
