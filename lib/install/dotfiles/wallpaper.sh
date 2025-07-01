# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------
_writeLogHeader "Wallpaper"

if [ -d "$HOME/.config/waypaper" ]; then
    _writeLogTerminal 0 "Waypaper configuration exists."
    echo "A new configuration is available and may be important for compatibility or features."
    if gum confirm "Do you want to KEEP your configuration?" --affirmative "KEEP" --negative "REPLACE"; then
        _writeLogTerminal 0 "Keeping existing Waypaper configuration. New version not applied."
    else
        _writeLogTerminal 1 "User chose to overwrite Waypaper configuration."
        rm -rf "$HOME/.config/waypaper"
        cp -r "$ml4w_directory/$version/.config/waypaper" "$HOME/.config/waypaper"
        _writeLogTerminal 1 "Waypaper configuration overwritten with the new version."
    fi
else
    _writeLogTerminal 0 "No existing Waypaper configuration found."
    cp -r "$ml4w_directory/$version/.config/waypaper" "$HOME/.config/waypaper"
    _writeLogTerminal 1 "Waypaper configuration installed."
fi

if [ -d "$HOME/wallpaper/" ]; then
    _writeLogTerminal 0 "$HOME/wallpaper folder already exists."
else
    _writeLogHeader "Wallpapers"
    mkdir -p "$HOME/wallpaper"
    cp "$wallpaper_directory"/* "$HOME/wallpaper/"
    _writeLogTerminal 1 "Default wallpapers installed successfully."
fi

echo
