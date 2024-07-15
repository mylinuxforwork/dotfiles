# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Wallpapers"
echo -e "${NONE}"
if [ ! -d ~/wallpaper ]; then
    echo "Do you want to download the wallpapers from repository https://github.com/mylinuxforwork/wallpaper/ ?"
    echo "If not, the script will install 3 default wallpapers in ~/wallpaper/"
    echo ""
    if gum confirm "Do you want to download the repository?" ;then
        if [ -d ~/Downloads/wallpaper ] ;then
            rm -rf ~/Downloads/wallpaper
        fi
        git clone --depth 1 https://github.com/mylinuxforwork/wallpaper.git ~/Downloads/wallpaper
        if [ ! -d ~/wallpaper/ ]; then
            mkdir ~/wallpaper
        fi
        rsync -a -I --exclude-from=.install/includes/excludes.txt ~/Downloads/wallpaper/. ~/wallpaper/
        echo "Wallpapers from the repository installed successfully."
    elif [ $? -eq 130 ]; then
        exit 130
    else
        if [ -d ~/wallpaper/ ]; then
            echo "~/wallpaper folder already exists."
        else
            mkdir ~/wallpaper
        fi
        cp .install/wallpapers/* ~/wallpaper
        echo "Default wallpapers installed successfully."
    fi
else
    echo ":: ~/wallpaper folder already exists."
fi
echo ""

# ------------------------------------------------------
# Copy default wallpaper files to .cache
# ------------------------------------------------------

# Cache file for holding the current wallpaper
cache_file="$HOME/.cache/current_wallpaper"
rasi_file="$HOME/.cache/current_wallpaper.rasi"

# Create cache file if not exists
if [ ! -f $cache_file ] ;then
    touch $cache_file
    echo "$HOME/wallpaper/default.jpg" > "$cache_file"
fi

# Create rasi file if not exists
if [ ! -f $rasi_file ] ;then
    touch $rasi_file
    echo "* { current-image: url(\"$HOME/wallpaper/default.jpg\", height); }" > "$rasi_file"
fi
