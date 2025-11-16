#!/usr/bin/env bash
#    ___           __
#   / _ \___  ____/ /__
#  / // / _ \/ __/  '_/
# /____/\___/\__/_/\_\
#

DOCK_THEME="modern"
if [ -f $HOME/.config/ml4w/settings/dock-theme ]; then
    DOCK_THEME=$(cat $HOME/.config/ml4w/settings/dock-theme)
fi
echo ":: Using Dock Theme $DOCK_THEME"
if [ ! -f $HOME/.config/ml4w/settings/dock-disabled ]; then
    killall nwg-dock-hyprland
    sleep 0.5
    nwg-dock-hyprland -i 32 -w 5 -mb 10 -x -s themes/$DOCK_THEME/style.css -c "$HOME/.config/hypr/scripts/launcher.sh"
else
    echo ":: Dock disabled"
fi