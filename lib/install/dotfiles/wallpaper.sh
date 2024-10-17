# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------

echo -e "${GREEN}"
figlet -f smslant "Wallpapers"
echo -e "${NONE}"

if [ -d ~/.config/waypaper ]; then
    echo ":: Waypaper configuration exists"
    rm -rf $ml4w_directory/$version/.config/waypaper
else
    if [ -d ~/wallpaper/ ]; then
        echo ":: ~/wallpaper folder already exists."
    else
        mkdir ~/wallpaper
        cp $wallpaper_directory/* ~/wallpaper/
        echo ":: Default wallpapers installed successfully."
        echo
        echo "You can download and install additional wallpapers from https://github.com/mylinuxforwork/wallpaper/"
        echo ""
        if gum confirm "Do you want to download the repository?" ;then
            if [ -d ~/Downloads/wallpaper ] ;then
                rm -rf ~/Downloads/wallpaper
            fi
            git clone --depth 1 https://github.com/mylinuxforwork/wallpaper.git ~/Downloads/wallpaper
            rsync -a -I --exclude-from=$install_directory/includes/excludes.txt ~/Downloads/wallpaper/. ~/wallpaper/
            echo "Wallpapers from the repository installed successfully."
        elif [ $? -eq 130 ]; then
            exit 130
        else
            echo ":: Installation of wallpaper repository skipped."
        fi
    fi
fi
echo

