#!/usr/bin/env bash
# Toggles between light and dark themes for GTK

GTK3_SETTINGS_FILE="$HOME/.config/gtk-3.0/settings.ini"
GTK4_SETTINGS_FILE="$HOME/.config/gtk-4.0/settings.ini"

# Check if GTK3 settings file exists
if [ ! -f "$GTK3_SETTINGS_FILE" ]; then
    echo "Error: $GTK3_SETTINGS_FILE not found."
    exit 1
fi

# Toggle theme based on current setting in GTK3 file (supports 1/0 and true/false)
if grep -qE "gtk-application-prefer-dark-theme=(1|true)" "$GTK3_SETTINGS_FILE"; then
    # Switch to light theme
    sed -i -E 's/gtk-application-prefer-dark-theme=(1|true)/gtk-application-prefer-dark-theme=0\ngtk-application-prefer-dark-theme=false/' "$GTK3_SETTINGS_FILE"
    sed -i '/gtk-application-prefer-dark-theme=false/!b;n;/gtk-application-prefer-dark-theme=false/d' "$GTK3_SETTINGS_FILE"
    sed -i '/gtk-application-prefer-dark-theme=0/!b;n;/gtk-application-prefer-dark-theme=0/d' "$GTK3_SETTINGS_FILE"
    if [ -f "$GTK4_SETTINGS_FILE" ]; then
        sed -i -E 's/gtk-application-prefer-dark-theme=(1|true)/gtk-application-prefer-dark-theme=false/' "$GTK4_SETTINGS_FILE"
    fi
    echo "Switched to light theme."
else
    # Switch to dark theme
    sed -i -E 's/gtk-application-prefer-dark-theme=(0|false)/gtk-application-prefer-dark-theme=1\ngtk-application-prefer-dark-theme=true/' "$GTK3_SETTINGS_FILE"
    sed -i '/gtk-application-prefer-dark-theme=true/!b;n;/gtk-application-prefer-dark-theme=true/d' "$GTK3_SETTINGS_FILE"
    sed -i '/gtk-application-prefer-dark-theme=1/!b;n;/gtk-application-prefer-dark-theme=1/d' "$GTK3_SETTINGS_FILE"
    if [ -f "$GTK4_SETTINGS_FILE" ]; then
        sed -i -E 's/gtk-application-prefer-dark-theme=(0|false)/gtk-application-prefer-dark-theme=true/' "$GTK4_SETTINGS_FILE"
    fi
    echo "Switched to dark theme."
fi
