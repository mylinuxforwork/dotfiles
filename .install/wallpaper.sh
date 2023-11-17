# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------
echo -e "${GREEN}"
cat <<"EOF"
__        __    _ _                                 
\ \      / /_ _| | |_ __   __ _ _ __   ___ _ __ ___ 
 \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__/ __|
  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |  \__ \
   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|  |___/
                   |_|         |_|                  

EOF
echo -e "${NONE}"
if [ ! -d ~/wallpaper ]; then
echo "Do you want to download the wallpapers from repository https://gitlab.com/stephan-raabe/wallpaper/ ?"
echo "If not, the script will install 3 default wallpapers in ~/wallpaper/"
echo ""
while true; do
    read -p "Do you want to download the repository? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/wallpaper/-/archive/main/wallpaper-main.zip
            unzip -o ~/Downloads/wallpaper-main.zip -d ~/Downloads/
            if [ ! -d ~/wallpaper/ ]; then
                mkdir ~/wallpaper
            fi
            cp ~/Downloads/wallpaper-main/* ~/wallpaper/
            echo "Wallpapers frpm the repository installed successfully."
        break;;
        [Nn]* ) 
            if [ -d ~/wallpaper/ ]; then
                echo "wallpaper folder already exists."
            else
                mkdir ~/wallpaper
            fi
            cp wallpapers/* ~/wallpaper
            echo "Default wallpapers installed successfully."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
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
