packagesPacman=(
    "xdg-desktop-portal-hyprland" 
    "waybar" 
    "grim" 
    "slurp"
    "swayidle"
    "swappy"
    "cliphist"
);

packagesYay=(
    "swww" 
    "swaylock-effects-git" 
    "wlogout"
);

if [[ $(_isInstalledYay "nwg-look") == 0 ]]; then
    echo ":: nwg-look is already installed."
else
    if [[ $(_isInstalledYay "nwg-look-bin") == 0 ]]; then
        echo ":: nwg-look-bin is already installed."
    else
        echo ":: Starting installation of nwg-look-bin"
        yay --noconfirm -S nwg-look-bin
    fi    
fi