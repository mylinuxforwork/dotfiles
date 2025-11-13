#!/usr/bin/env bash
# ML4W Theme Modern

# Set waybar
echo "/ml4w-modern;/ml4w-modern/default" > $HOME/.config/ml4w/settings/waybar-theme.sh
$HOME/.config/waybar/launch.sh &

# Set nwg-dock-hyprland
echo "modern" > $HOME/.config/ml4w/settings/dock-theme
$HOME/.config/nwg-dock-hyprland/launch.sh &

# Set swaync
echo '@import "themes/modern/style.css";' > $HOME/.config/swaync/style.css
swaync-client -rs

# Set wlogout
echo '@import "themes/modern/style.css";' > $HOME/.config/wlogout/style.css

# Set launcher

# Set rofi
echo '* { border-width: 2px; }' > $HOME/.config/ml4w/settings/rofi-border.rasi

echo ":: Theme set to Modern"