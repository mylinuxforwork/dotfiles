# ------------------------------------------------------
# init pywal with default wallpaper
# ------------------------------------------------------

if [ ! -f ~/.cache/wal/colors-hyprland.conf ]; then
    echo -e "${GREEN}"
    figlet -f smslant "Pywal"
    echo -e "${NONE}"
    wal -ei "$HOME/$wallpaper_folder/default.jpg"
    echo ":: Pywal and templates activated."
    echo ""
else
    echo ":: Pywal already activated."
    echo ""
fi
