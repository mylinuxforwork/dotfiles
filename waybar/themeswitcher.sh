#!/bin/bash
options=$(find ~/dotfiles/waybar/themes/ -maxdepth 2 -type d)
listThemes=""
for value in $options
do
    if [ ! $value == "$HOME/dotfiles/waybar/themes/" ]; then
        if [ $(find $value -maxdepth 1 -type d | wc -l) = 1 ]; then
            result=$(echo $value | sed "s#$HOME/dotfiles/waybar/themes/#/#g")
            IFS='/' read -ra arrThemes <<< "$result"
            echo $arrThemes
            listThemes+="/${arrThemes[1]};$result\n"
        fi
    fi
done

listThemes=${listThemes::-2}

choice=$(echo -e "$listThemes" | rofi -dmenu -config ~/dotfiles/rofi/config-wallpaper.rasi -no-show-icons -width 30 -p "Themes") 
if [ "$choice" ]; then
    echo "$choice" > ~/.cache/.themestyle.sh
    ~/dotfiles/waybar/launch.sh
fi
