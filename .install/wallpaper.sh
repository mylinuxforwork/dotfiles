# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Wallpapers"
echo -e "${NONE}"
if [ ! -d ~/wallpaper ]; then
    echo "Do you want to download the wallpapers from repository https://gitlab.com/stephan-raabe/wallpaper/ ?"
    echo "If not, the script will install 3 default wallpapers in ~/wallpaper/"
    echo ""
    if gum confirm "Do you want to download the repository?" ;then
        wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/wallpaper/-/archive/main/wallpaper-main.zip
        unzip -o ~/Downloads/wallpaper-main.zip -d ~/Downloads/
        if [ ! -d ~/wallpaper/ ]; then
            mkdir ~/wallpaper
        fi
        cp ~/Downloads/wallpaper-main/* ~/wallpaper/
        echo "Wallpapers from the repository installed successfully."
    elif [ $? -eq 130 ]; then
        exit 130
    else
        if [ -d ~/wallpaper/ ]; then
            echo "wallpaper folder already exists."
        else
            mkdir ~/wallpaper
        fi
        cp wallpapers/* ~/wallpaper
        echo "Default wallpapers installed successfully."
    fi
else
    echo "~/wallpaper folder already exsits."
fi
echo ""

# ------------------------------------------------------
# Copy default wallpaper to .cache
# ------------------------------------------------------
if [ ! -f ~/.cache/current_wallpaper.jpg ]; then
    cp wallpapers/default.jpg ~/.cache/current_wallpaper.jpg
    echo "Default wallpaper installed."
    echo ""
fi
