echo -e "${GREEN}"
figlet "System check"
echo -e "${NONE}"

echo "The system check will test that essential packages and "
echo "execution commands are available now on your system."
echo 
if gum confirm "Do you want to run a short system check?" ;then

    _folderExists "$HOME/dotfiles" "Please repeat the installation."
    _commandExists "rofi" "rofi-wayland"
    _commandExists "dunst" "dunst"
    _commandExists "waybar" "waybar"
    _commandExists "hyprpaper" "hyprpaper"
    _commandExists "hyprlock" "hyprpaper"
    _commandExists "hypridle" "hyprpaper"
    _commandExists "wal" "python-pywal"
    _commandExists "gum" "gum"
    _commandExists "wlogout" "wlogout"
    _commandExists "eww" "eww"
    _commandExists "magick" "imagemagick"
    _commandExists "waypaper" "waypaper"

elif [ $? -eq 130 ]; then
    exit 130
else
    echo ":: System check skipped"
fi
echo ""