# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------

cat <<"EOF"
__        __    _ _                                 
\ \      / /_ _| | |_ __   __ _ _ __   ___ _ __ ___ 
 \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__/ __|
  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |  \__ \
   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|  |___/
                   |_|         |_|                  

EOF

echo "Do you want to download the wallpapers from repository https://gitlab.com/stephan-raabe/wallpaper/ ?"
while true; do
    read -p "If not, the script will install 3 default wallpapers to ~/wallpaper/ (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/wallpaper/-/archive/main/wallpaper-main.zip
            unzip -o ~/Downloads/wallpaper-main.zip -d ~/Downloads/
            if [ ! -d ~/wallpaper/ ]; then
                mkdir ~/wallpaper
            fi
            cp ~/Downloads/wallpaper-main/* ~/wallpaper/
            echo "Wallpapers installed successfully."
        break;;
        [Nn]* ) 
            if [ -d ~/wallpaper/ ]; then
                echo "wallpaper folder already exists."
            else
                mkdir ~/wallpaper
            fi
            cp wallpapers/* ~/wallpaper
            echo "Default wallpapers installed."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""

# ------------------------------------------------------
# Copy default wallpaper to .cache
# ------------------------------------------------------
cp wallpapers/default.jpg ~/.cache/current_wallpaper.jpg
echo ""
