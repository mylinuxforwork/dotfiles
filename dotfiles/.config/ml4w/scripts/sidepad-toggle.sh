#!/usr/bin/env bash
#    _____    __                 __
#   / __(_)__/ /__ ___  ___ ____/ /
#  _\ \/ / _  / -_) _ \/ _ `/ _  / 
# /___/_/\_,_/\__/ .__/\_,_/\_,_/  
#               /_/                
#

# Load Settings Parameters
sidepad_options=$(cat "$HOME/.config/ml4w/settings/sidepad-options.sh")

# Toggle Sidepad
if [[ "$1" == "--hide" ]]; then
~/.config/ml4w/scripts/sidepad.sh --hide $sidepad_options
else
~/.config/ml4w/scripts/sidepad.sh $sidepad_options
fi