# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------

wallpaper_folder="wallpaper"

_define_wallpaper_folder() {
    echo ":: Please enter the name of the folder to store wallpapers starting from your home directory."
    echo ":: (e.g., wallpaper or Documents/wallpaper, ...)"
    wallpaper_folder_tmp=$(gum input --value "$wallpaper_folder" --placeholder "Enter your wallpaper folder name")
    wallpaper_folder=${wallpaper_folder_tmp//[[:blank:]]/}
    if [[ $wallpaper_folder == ".ml4w-hyprland" ]] ;then
        echo ":: The folder .ml4w-hyprland is not allowed."
        _define_wallpaper_folder
    elif [ $? -eq 130 ] ;then
        echo ":: Wallpaper installation canceled."
        exit 130
    elif [ ! -z $wallpaper_folder ] ;then
        _confirm_wallpaper_folder
    else
        echo "ERROR: Please define a folder name"
        _define_wallpaper_folder
    fi
}

_confirm_wallpaper_folder() {
    echo ":: The wallpapers will be stored to ~/$wallpaper_folder"
    echo
    if gum confirm "Do you want use this folder?" ;then
        if [ ! -d ~/$wallpaper_folder ] ;then 
            mkdir ~/$wallpaper_folder
        fi
    elif [ $? -eq 130 ] ;then
        echo ":: Wallpaper installation canceled."
        exit 130
    else
        _define_wallpaper_folder
    fi
}

_find_wallpaper_folder_cache() {
    wallpaper_cache_path="$ml4w_directory/$version/.config/ml4w/settings/wallpaper-folder.sh"
    wallpaper_folder_default=$(grep -v "^[[:space:]]*#" $share_directory/dotfiles/.config/ml4w/settings/wallpaper-folder.sh | head -n 1)
    wallpaper_folder_tmp="$wallpaper_folder_default"

    if [ -f "$wallpaper_cache_path" ] ;then
        wallpaper_folder_tmp=$(grep -v "^[[:space:]]*#" $wallpaper_cache_path | head -n 1)
    elif [ -f ~/.config/ml4w/settings/wallpaper-folder.sh ]; then
        wallpaper_folder_tmp=$(grep -v "^[[:space:]]*#" ~/.config/ml4w/settings/wallpaper-folder.sh | head -n 1)
    fi

    if [ "$wallpaper_folder_default" != "$wallpaper_folder_tmp" ] ;then
        wallpaper_folder=$(echo $wallpaper_folder_tmp | cut -d "=" -f 2- | sed "s|\$HOME/||" | sed "s|$HOME/||")
        echo ":: An existing wallpaper folder has been detected: ~/$wallpaper_folder"
    fi
}

_install_wallpapers() {
    cp $wallpaper_directory/* ~/$wallpaper_folder/
    echo ":: Default wallpapers installed successfully."
    echo
    echo "You can download and install additional wallpapers from https://github.com/mylinuxforwork/wallpaper/"
    echo
    if gum confirm "Do you want to download the repository?" ;then
        if [ -d ~/Downloads/wallpaper ] ;then
            rm -rf ~/Downloads/wallpaper
            echo ":: ~/Downloads/wallpaper deleted"
        fi
        git clone --depth 1 https://github.com/mylinuxforwork/wallpaper.git ~/Downloads/wallpaper
        rsync -a -I --exclude-from=$install_directory/includes/excludes.txt ~/Downloads/wallpaper/. ~/$wallpaper_folder/
        echo "Wallpapers from the repository installed successfully."
    elif [ $? -eq 130 ] ;then
        exit 130
    else
        echo ":: Installation of wallpaper repository skipped."
    fi
    echo
}

_cache_wallpapers() {
    # ------------------------------------------------------
    # Copy default wallpaper files to .cache
    # ------------------------------------------------------

    # Cache file for holding the current wallpaper
    cache_file="$HOME/.config/ml4w/cache/current_wallpaper"
    rasi_file="$HOME/.config/ml4w/cache/current_wallpaper.rasi"

    # Create cache file if not exists
    if [ ! -f $cache_file ] ;then
        touch $cache_file
        echo "~/$wallpaper_folder/default.jpg" > "$cache_file"
    fi

    # Create rasi file if not exists
    if [ ! -f $rasi_file ] ;then
        touch $rasi_file
        echo "* { current-image: url(\"~/$wallpaper_folder/default.jpg\", height); }" > "$rasi_file"
    fi
}

echo -e "${GREEN}"
figlet -f smslant "Wallpapers"
echo -e "${NONE}"
_find_wallpaper_folder_cache
_confirm_wallpaper_folder
_install_wallpapers
_cache_wallpapers
