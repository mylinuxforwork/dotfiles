# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------
_writeLogHeader "Wallpaper"

if [ -d $HOME/.config/waypaper ]; then
    _writeLog 0 "Waypaper configuration exists"
    rm -rf $ml4w_directory/$version/.config/waypaper
else
    if [ -d ~/wallpaper/ ]; then
        _writeLog 0 "$HOME/wallpaper folder already exists."
    else
        _writeHeader "Wallpapers"
        mkdir -p $HOME/wallpaper
        cp $wallpaper_directory/* ~/wallpaper/
        _writeLog 1 "Default wallpapers installed successfully."
    fi
fi
echo
