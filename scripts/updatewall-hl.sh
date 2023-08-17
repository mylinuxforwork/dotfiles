#!/bin/bash

wal -q -i ~/wallpaper/
source "$HOME/.cache/wal/colors.sh"
newwall=$(echo $wallpaper | sed "s|$HOME/wallpaper/||g")
swww img $wallpaper --transition-step 20 --transition-fps=20



