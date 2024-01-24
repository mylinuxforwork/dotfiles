#!/bin/bash
if [ ! -f $HOME/.cache/ml4w-welcome-autostart ] ;then
    echo "Autostart of ML4W Welcome App enabled."
    if [ -f $HOME/dotfiles/apps/ML4W_Welcome-x86_64.AppImage ] ;then
        echo "Starting ML4W Welcome App ..."
        sleep 2
        $HOME/dotfiles/apps/ML4W_Welcome-x86_64.AppImage
    else
        echo "ML4W Welcome App not found."
    fi

else
    echo "Autostart of ML4W Welcome App disabled."
fi