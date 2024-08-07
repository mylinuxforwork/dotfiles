echo -e "${GREEN}"
figlet "Diagnosis"
echo -e "${NONE}"

echo "The system check will test that essential packages and "
echo "execution commands are available now on your system."
echo 
if gum confirm "Do you want to run a short system check?" ;then
    _commandExists "rofi" "rofi-wayland"
    _commandExists "dunst" "dunst"
    _commandExists "waybar" "waybar"
    _commandExists "hyprpaper" "hyprpaper"
    _commandExists "hyprlock" "hyprlock"
    _commandExists "hypridle" "hypridle"
    _commandExists "hyprshade" "hyprshade"
    _commandExists "wal" "python-pywal"
    _commandExists "gum" "gum"
    _commandExists "wlogout" "wlogout"
    _commandExists "ags" "ags"
    _commandExists "magick" "imagemagick"
    _commandExists "waypaper" "waypaper"
    echo
    if gum confirm "Do you want to proceed?" ;then
        echo
    elif [ $? -eq 130 ]; then
        echo ":: Installation canceled."
        exit 130
    else
        echo ":: Installation canceled"
        exit
    fi
elif [ $? -eq 130 ]; then
    exit 130
else
    echo ":: System check skipped"
fi
echo ""