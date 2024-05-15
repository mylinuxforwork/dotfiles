#!/bin/bash
hyprshade_filter="blue-light-filter"
if [ -f ~/dotfiles/.settings/hyprshade.sh ] ;then
    source ~/dotfiles/.settings/hyprshade.sh
fi
if [ "$hyprshade_filter" != "off" ] ;then
    if [ -z $(hyprshade current) ] ;then
        echo ":: hyprshade is not running"
        hyprshade on $hyprshade_filter
        echo ":: hyprshade started with $(hyprshade current)"
    else
        echo ":: Current hyprshade $(hyprshade current)"
        echo ":: Switching hyprshade off"
        hyprshade off
    fi
else
    if [ -z $(hyprshade current) ] ;then
        hyprshade off
    fi
    echo ":: hyprshade turned off"
fi
