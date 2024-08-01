# ------------------------------------------------------
# init pywal with default wallpaper
# ------------------------------------------------------

if [ ! -f ~/.cache/wal/colors-hyprland.conf ]; then
    wal -i ~/wallpaper/default.jpg
    echo "Pywal and templates activated."
    echo ""
else
    echo "Pywal already activated."
    echo ""
fi