#!/bin/bash
#  _   _           _       _                 _     _
# | | | |_ __   __| | __ _| |_ ___   ___  __| | __| |_ __ ___
# | | | | '_ \ / _` |/ _` | __/ _ \ / __|/ _` |/ _` | '_ ` _ \
# | |_| | |_) | (_| | (_| | ||  __/ \__ \ (_| | (_| | | | | | |
#  \___/| .__/ \__,_|\__,_|\__\___| |___/\__,_|\__,_|_| |_| |_|
#       |_|
#
# by Stephan Raabe (2024)
# -----------------------------------------------------
sleep 1
clear
cache_file="$HOME/.config/ml4w/cache/current_wallpaper"
current_wallpaper=$(cat "$cache_file")
extension="${current_wallpaper##*.}"

echo -e "${GREEN}"
figlet -f smslant "SDDM Wallpaper"
echo -e "${NONE}"

sddm_theme_name="sequoia"
sddm_asset_folder="/usr/share/sddm/themes/$sddm_theme_name/backgrounds"

sddm_theme_tpl="/usr/share/ml4w-hyprland/sddm/theme.conf"
if [ -f $HOME/.config/ml4w/settings/sddm/theme.conf ]; then
    sddm_theme_tpl="$HOME/.config/ml4w/settings/sddm/theme.conf"
    echo ":: Using custum theme.conf"
fi

if [ ! -f $current_wallpaper ]; then
    gum spin --spinner dot --title "File $current_wallpaper does not exist" -- sleep 3
    exit
fi

echo ":: Set the current wallpaper $current_wallpaper as SDDM wallpaper."
echo

if [ ! -d /etc/sddm.conf.d/ ]; then
    sudo mkdir /etc/sddm.conf.d
    echo ":: Folder /etc/sddm.conf.d created."
fi

sudo cp /usr/share/ml4w-hyprland/sddm/sddm.conf /etc/sddm.conf.d/
echo ":: File /etc/sddm.conf.d/sddm.conf updated."

sudo cp $current_wallpaper $sddm_asset_folder/current_wallpaper.$extension
echo ":: Current wallpaper copied into $sddm_asset_folder"

sudo cp $sddm_theme_tpl /usr/share/sddm/themes/$sddm_theme_name/
sudo sed -i 's/CURRENTWALLPAPER/'"current_wallpaper.$extension"'/' /usr/share/sddm/themes/$sddm_theme_name/theme.conf
echo ":: File theme.conf updated in /usr/share/sddm/themes/$sddm_theme_name/"
echo

echo ":: You can preview your updated SDDM Login screen. (Close it with SUPER+Q)"
echo
if gum confirm "Do you want to preview the result?"; then
    sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sequoia
fi

echo
gum spin --spinner dot --title "Please logout to see the result." -- sleep 3
