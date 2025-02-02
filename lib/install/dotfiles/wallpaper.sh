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
        echo
        _writeMessage "You can download and install additional wallpapers from https://github.com/mylinuxforwork/wallpaper/"
        echo
        if gum confirm "Do you want to download the repository?" ;then
            if [ -d $download_folder/wallpaper ] ;then
                rm -rf $download_folder/wallpaper
            fi
            git clone --depth 1 https://github.com/mylinuxforwork/wallpaper.git $download_folder/wallpaper
            rsync -a -I --exclude-from=$includes_directory/excludes.txt $download_folder/wallpaper/. ~/wallpaper/ &>> $(_getLogFile)
            _writeLogHeader 1 "Wallpapers from the repository installed successfully."
        elif [ $? -eq 130 ]; then
            exit 130
        else
            _writeSkipped
        fi
    fi
fi
echo

