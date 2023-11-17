# ------------------------------------------------------
# init pywal with default wallpaper
# ------------------------------------------------------

if [ ! -f ~/.cache/wal/colors-hyprland.conf ]; then
    _installSymLink wal ~/.config/wal ~/dotfiles/wal/ ~/.config
    wal -i ~/dotfiles/wallpapers/default.jpg
    echo "Pywal and templates activated."
    echo ""
else
    echo "Pywal already activated."
    echo ""
fi