#!/usr/bin/env bash
#    _____    __                 __
#   / __(_)__/ /__ ___  ___ ____/ /
#  _\ \/ / _  / -_) _ \/ _ `/ _  / 
# /___/_/\_,_/\__/ .__/\_,_/\_,_/  
#               /_/                
#

sidepad_init=$(cat "$HOME/.config/ml4w/settings/sidepad-init.sh")
eval "$HOME/.config/ml4w/scripts/sidepad.sh $sidepad_init" &

