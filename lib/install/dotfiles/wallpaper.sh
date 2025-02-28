# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------
_writeLogHeader "Wallpaper"

if [ -d $HOME/.config/waypaper ]; then
    _writeLogTerminal 0 "Waypaper configuration exists"
    rm -rf $ml4w_directory/$version/.config/waypaper
else
    if [ -d ~/wallpaper/ ]; then
        _writeLogTerminal 0 "$HOME/wallpaper folder already exists."
    else
        _writeHeader "Wallpapers"
        mkdir -p $HOME/wallpaper
        cp $wallpaper_directory/* ~/wallpaper/
        _writeLogTerminal 1 "Default wallpapers installed successfully."
    fi
fi
echo