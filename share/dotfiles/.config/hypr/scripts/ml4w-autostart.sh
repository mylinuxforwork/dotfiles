#!/bin/bash
if [ -f ~/.config/ml4w/version/compare.sh ] ;then
    $HOME/.config/ml4w/version/compare.sh
fi

if [ ! -f ~/.cache/ml4w-post-install ] ;then
    if [ ! -f $HOME/.cache/ml4w-welcome-autostart ] ;then
        echo ":: Autostart of ML4W Welcome App enabled."
        if [ -f $HOME/.config/ml4w/apps/ML4W_Welcome-x86_64.AppImage ] ;then
            echo ":: Starting ML4W Welcome App ..."
            sleep 2
            $HOME/.config/ml4w/apps/ML4W_Welcome-x86_64.AppImage
        else
            echo ":: ML4W Welcome App not found."
        fi

    else
        echo ":: Autostart of ML4W Welcome App disabled."
    fi
else
    rm ~/.cache/ml4w-post-install
    terminal=$(cat ~/.config/ml4w/settings/terminal.sh)
    $terminal --class dotfiles-floating -e ~/.config/ml4w/postinstall.sh
    $HOME/.config/ml4w/apps/ML4W_Welcome-x86_64.AppImage
fi
