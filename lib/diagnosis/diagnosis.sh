clear
sleep 0.5
echo -e "${GREEN}"
figlet -f smslant "Diagnosis"
echo -e "${NONE}"
echo "This script will check that essential packages and "
echo "execution commands are available on your system."
echo

_commandExists() {
    package="$1";
    if ! type $package > /dev/null 2>&1; then
        echo ":: ERROR: $package doesn't exists. Please install it with yay -S $2"
    else
        echo ":: OK: $package found."
    fi
}

_folderExists() {
    folder="$1";
    if [ ! -d $folder ]; then
        echo ":: ERROR: $folder doesn't exists."
    else
        echo ":: OK: $folder found."
    fi
}

_commandExists "rofi" "rofi-wayland"
_commandExists "dunst" "dunst"
_commandExists "waybar" "waybar"
_commandExists "hyprpaper" "hyprpaper"
_commandExists "hyprlock" "hyprpaper"
_commandExists "hypridle" "hyprpaper"
_commandExists "hyprshade" "hyprshade"
_commandExists "wal" "python-pywal"
_commandExists "gum" "gum"
_commandExists "wlogout" "wlogout"
_commandExists "ags" "ags"
_commandExists "magick" "imagemagick"
_commandExists "figlet" "figlet"
_commandExists "waypaper" "waypaper"

echo
echo "Press return to exit"
read