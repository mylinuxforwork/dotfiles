#!/usr/bin/env bash

# This script monitors changes to the GTK settings.ini file
# and automatically switches the 'matugen' theme between light and dark
# based on the 'gtk-application-prefer-dark-theme' setting.

# Path to the GTK settings file
SETTINGS_FILE="$HOME/.config/gtk-3.0/settings.ini"
SETTINGS_DIR="$HOME/.config/gtk-3.0"
SETTINGS_BASENAME=$(basename "$SETTINGS_FILE")

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

    if [[ "$THEME_PREF" == "1" || "$THEME_PREF" == "true" ]]; then
        echo "Detected dark theme preference (gtk-application-prefer-dark-theme=1/true). Applying dark matugen theme..."
        $HOME/.local/bin/matugen image $(cat ~/.cache/ml4w/hyprland-dotfiles/current_wallpaper)
        $HOME/.config/nwg-dock-hyprland/launch.sh &
        $HOME/.config/waybar/launch.sh &
        $HOME/.config/hypr/scripts/gtk.sh &
        swaync-client -rs
    elif [[ "$THEME_PREF" == "0" || "$THEME_PREF" == "false" ]]; then
        echo "Detected light theme preference (gtk-application-prefer-dark-theme=0/false). Applying light matugen theme..."
        $HOME/.local/bin/matugen image $(cat ~/.cache/ml4w/hyprland-dotfiles/current_wallpaper) -m "light"
        $HOME/.config/nwg-dock-hyprland/launch.sh &
        $HOME/.config/waybar/launch.sh &
        $HOME/.config/hypr/scripts/gtk.sh &
        swaync-client -rs
    else
        echo "Warning: Unexpected value for gtk-application-prefer-dark-theme: $THEME_PREF. Expected 0/1/true/false. Skipping theme application."
    fi
}

# Loop indefinitely, reading output from inotifywait
inotifywait -m -q -e close_write,moved_to "$SETTINGS_DIR" | while read -r dir events filename; do
    if [[ "$filename" == "$SETTINGS_BASENAME" ]]; then
        echo "Change detected in $SETTINGS_FILE. Re-applying theme..."
        apply_theme
    fi
done