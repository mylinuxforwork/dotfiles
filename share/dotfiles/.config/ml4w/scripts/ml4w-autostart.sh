#!/bin/bash

# Compare installed version with running dotfiles
if [ -f ~/.config/ml4w/version/compare.sh ]; then
    $HOME/.config/ml4w/version/compare.sh
fi

# Start ML4W Welcome App
if [ ! -f $HOME/.cache/ml4w-welcome-autostart ]; then
    echo ":: Starting ML4W Welcome App ..."
    sleep 2
    flatpak run com.ml4w.welcome
else
    echo ":: Autostart of ML4W Welcome App disabled."
fi
