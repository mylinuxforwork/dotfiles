#!/bin/sh

xrandr --rate 120
setxkbmap de
picom &
xfce4-power-manager &
dunst &
~/dotfiles/scripts/updatewal.sh
spotifyd
