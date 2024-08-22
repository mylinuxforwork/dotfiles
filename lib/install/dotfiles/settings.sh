# ------------------------------------------------------
# Restore ML4W Hyprland Settings app
# ------------------------------------------------------

echo ":: Starting restore settings"
if [ "$restored" == "1" ]; then
    if [ -f ~/.config/ml4w/settings/settings.json ] ;then
        python $install_directory/dotfiles/restore.py
    fi
else
    if [ -f ~/.config/ml4w/settings/settings.json ] ;then
        rm ~/.config/ml4w/settings/settings.json
        echo ":: settings.json removed"
    fi
    if [ -f ~/.cache/.themestyle.sh ] ;then
        rm ~/.cache/.themestyle.sh
        echo ":: .themestyle.sh removed"
    fi
fi