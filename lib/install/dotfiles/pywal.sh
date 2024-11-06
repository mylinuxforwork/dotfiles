# ------------------------------------------------------
# init pywal with default wallpaper
# ------------------------------------------------------
_writeLogHeader "Pywal"
_writeHeader "Pywal"

if [ ! -f ~/.cache/wal/colors-hyprland.conf ]; then
    wal -ei ~/wallpaper/default.jpg
    echo ":: Pywal and templates activated."
    echo ""
else
    echo ":: Pywal already activated."
    echo ""
fi