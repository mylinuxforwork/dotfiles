#!/bin/bash
cache_file="$HOME/.cache/current_animation"
if [[ "$1" == "toggle" ]]; then
    if [[ ! $(cat $HOME/dotfiles/hypr/conf/animation.conf) == *"disabled"* ]]; then
        if [ ! -f $cache_file ] ;then
            touch $cache_file
            echo $(cat $HOME/dotfiles/hypr/conf/animation.conf) > "$cache_file"
            echo "source = ~/dotfiles/hypr/conf/animations/disabled.conf" > "$HOME/dotfiles/hypr/conf/animation.conf"
        else
            echo $(cat "$cache_file") > "$HOME/dotfiles/hypr/conf/animation.conf"
            rm $cache_file
        fi
    fi
else
    if [ -f $cache_file ] ;then
        rm $cache_file
    fi
    echo "source = ~/dotfiles/hypr/conf/animations/default.conf" > "$HOME/dotfiles/hypr/conf/animation.conf"
fi