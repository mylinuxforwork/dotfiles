# ------------------------------------------------------
# Clean up
# ------------------------------------------------------

echo -e "${GREEN}"
figlet -f smslant "Clean up"
echo -e "${NONE}"

# Cache file for holding the current wallpaper
cache_file="$HOME/.config/ml4w/cache/current_wallpaper"
rasi_file="$HOME/.config/ml4w/cache/current_wallpaper.rasi"

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

# Check for ttf-ms-fonts
if [[ $(_isInstalledPacman "ttf-ms-fonts") == 0 ]]; then
    echo "The script has detected ttf-ms-fonts. This can cause conflicts with icons in Waybar."
    if gum confirm "Do you want to uninstall ttf-ms-fonts?" ;then
        sudo pacman --noconfirm -R ttf-ms-fonts
    fi
fi

# Check for running NetworkManager.service
if [[ $(systemctl list-units --all -t service --full --no-legend "NetworkManager.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "NetworkManager.service" ]];then
    echo ":: NetworkManager.service already running."
else
    sudo systemctl enable NetworkManager.service
    sudo systemctl start NetworkManager.service
    echo ":: NetworkManager.service activated successfully."    
fi

# Check for running bluetooth.service
if [[ $(systemctl list-units --all -t service --full --no-legend "bluetooth.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "bluetooth.service" ]];then
    echo ":: bluetooth.service already running."
else
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    echo ":: bluetooth.service activated successfully."    
fi

if [ -d ~/$dot_folder/hypr/settings/ ] ;then
    rm -rf ~/dotfiles/hypr/settings
    echo ":: ~/dotfiles/hypr/settings removed."
fi

if [ -f ~/.local/share/applications/ml4w-welcome.desktop ] ;then
    rm ~/.local/share/applications/ml4w-welcome.desktop
fi
if [ -f ~/.local/share/applications/ml4w-dotfiles-settings.desktop ] ;then
    rm ~/.local/share/applications/ml4w-dotfiles-settings.desktop
fi
if [ -f ~/.local/share/applications/ml4w-hyprland-settings.desktop ] ;then
    rm ~/.local/share/applications/ml4w-hyprland-settings.desktop
fi


# Create default folder structure
xdg-user-dirs-update

echo 
echo ":: Cleanup done."