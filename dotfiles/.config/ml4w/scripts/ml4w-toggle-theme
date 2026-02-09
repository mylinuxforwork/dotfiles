#!/usr/bin/env bash
# Toggles between light and dark themes for GTK

GTK3_SETTINGS_FILE="$HOME/.config/gtk-3.0/settings.ini"
GTK4_SETTINGS_FILE="$HOME/.config/gtk-4.0/settings.ini"

# Check if GTK3 settings file exists
if [ ! -f "$GTK3_SETTINGS_FILE" ]; then
    echo "Error: $GTK3_SETTINGS_FILE not found."
    exit 1
fi

# Toggle theme based on current setting in GTK3 file
if grep -q "gtk-application-prefer-dark-theme=1" "$GTK3_SETTINGS_FILE"; then
    # Switch to light theme
    sed -i 's/gtk-application-prefer-dark-theme=1/gtk-application-prefer-dark-theme=0/' "$GTK3_SETTINGS_FILE"
    if [ -f "$GTK4_SETTINGS_FILE" ]; then
        sed -i 's/gtk-application-prefer-dark-theme=true/gtk-application-prefer-dark-theme=false/' "$GTK4_SETTINGS_FILE"
    fi
    echo "Switched to light theme."
else
    # Switch to dark theme
    sed -i 's/gtk-application-prefer-dark-theme=0/gtk-application-prefer-dark-theme=1/' "$GTK3_SETTINGS_FILE"
    if [ -f "$GTK4_SETTINGS_FILE" ]; then
        sed -i 's/gtk-application-prefer-dark-theme=false/gtk-application-prefer-dark-theme=true/' "$GTK4_SETTINGS_FILE"
    fi
    echo "Switched to dark theme."
fi