# ------------------------------------------------------
# Install tty login and issue
# ------------------------------------------------------
echo -e "${GREEN}"
figlet "Cleanup"
echo -e "${NONE}"

# Check for ttf-ms-fonts
if [[ $(_isInstalledPacman "ttf-ms-fonts") == 0 ]]; then
    echo "The script has detected ttf-ms-fonts. This can cause conflicts with icons in Waybar."
    if gum confirm "Do you want to uninstall ttf-ms-fonts?" ;then
        sudo pacman --noconfirm -R ttf-ms-fonts
    fi
fi

# Check for running NetworkManager.service
if [[ $(systemctl list-units --all -t service --full --no-legend "NetworkManager.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "NetworkManager.service" ]];then
    echo "NetworkManager.service already running."
else
    sudo systemctl enable NetworkManager.service
    sudo systemctl start NetworkManager.service
    echo "NetworkManager.service activated successfully."    
fi

# Check for running bluetooth.service
if [[ $(systemctl list-units --all -t service --full --no-legend "bluetooth.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "bluetooth.service" ]];then
    echo "bluetooth.service already running."
else
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    echo "bluetooth.service activated successfully."    
fi

if [ -d ~/dotfiles/hypr/settings/modules/waybar/defaults ] ;then
    rm -rf ~/dotfiles/hypr/settings/modules/waybar/defaults
    echo "~/dotfiles/hypr/settings/modules/waybar/defaults removed."
fi

if [ -d ~/dotfiles/hypr/settings/modules/sddm ] ;then
    rm -rf ~/dotfiles/hypr/settings/modules/sddm
    echo "~/dotfiles/hypr/settings/modules/sddm removed."
fi

if [ -d ~/dotfiles/hypr/settings/modules/appearance/wallpaper ] ;then
    rm -rf ~/dotfiles/hypr/settings/modules/appearance/wallpaper
    echo "~/dotfiles/hypr/settings/modules/appearance/wallpaper removed."
fi

if [ -d ~/dotfiles/hypr/settings/modules/system/swaylock ] ;then
    rm -rf ~/dotfiles/hypr/settings/modules/system/swaylock
    echo "~/dotfiles/hypr/settings/modules/system/swaylock removed."
fi

if [ -d ~/dotfiles/hypr/settings/modules/waybar/bluetooth ] ;then
    rm -rf ~/dotfiles/hypr/settings/modules/waybar/bluetooth
    echo "~/dotfiles/hypr/settings/modules/waybar/bluetooth removed."
fi

# Create default folder structure
xdg-user-dirs-update
echo 

echo "Cleanup done."