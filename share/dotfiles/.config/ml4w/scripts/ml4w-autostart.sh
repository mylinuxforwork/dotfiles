#!/bin/bash
if [ -f ~/.config/ml4w/version/compare.sh ] ;then
    $HOME/.config/ml4w/version/compare.sh
fi

if [ ! -f ~/.cache/ml4w-post-install ] ;then
    if [ ! -f $HOME/.cache/ml4w-welcome-autostart ] ;then
        echo ":: Starting ML4W Welcome App ..."
        sleep 2
        com.ml4w.welcome
    else
        echo ":: Autostart of ML4W Welcome App disabled."
    fi
else
    rm ~/.cache/ml4w-post-install
    terminal=$(cat ~/.config/ml4w/settings/terminal.sh)
    $terminal --class dotfiles-floating -e ml4w-hyprland-setup -m options
    com.ml4w.welcome
fi
