#!/bin/bash
# screen=0
screen=$(hyprctl activewindow -j | jq '.monitor')
echo $screen