# ------------------------------------------------------
# Diagnosis
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "Diagnosis"
echo -e "${NONE}"
echo ":: AUTOMATION: Run diagnosis script"
echo
_folderExists "$HOME/$dot_folder" "Please repeat the installation."
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
_commandExists "waypaper" "waypaper"
