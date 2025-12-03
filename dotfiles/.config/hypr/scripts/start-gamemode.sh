#!/usr/bin/env bash
#                                      __   
#   ___ ____ ___ _  ___ __ _  ___  ___/ /__ 
#  / _ `/ _ `/  ' \/ -_)  ' \/ _ \/ _  / -_)
#  \_, /\_,_/_/_/_/\__/_/_/_/\___/\_,_/\__/ 
# /___/                                     
# 

ml4w_cache_folder="$HOME/.cache/ml4w/hyprland-dotfiles"
gamemode_monitor="$HOME/.config/hypr/conf/monitors/gamemode.conf"

if [ -f $HOME/.config/ml4w/settings/gamemode-enabled ]; then
  rm $HOME/.config/ml4w/settings/gamemode-enabled
fi
