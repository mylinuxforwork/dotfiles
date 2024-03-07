#!/bin/bash

# ------------------------------------------------------
# Apps Installation
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "ML4W Apps"
echo -e "${NONE}"

if [ ! -d $HOME/.local/share/applications/ ] ;then
    mkdir $HOME/.local/share/applications
    echo ":: $HOME/.local/share/applications created"
fi

sed -i "s|HOME|${HOME}|g" $HOME/dotfiles/apps/ml4w-welcome.desktop
cp $HOME/dotfiles/apps/ml4w-welcome.desktop $HOME/.local/share/applications
echo ":: ML4W Welcome App installed successfully"

sed -i "s|HOME|${HOME}|g" $HOME/dotfiles/apps/ml4w-dotfiles-settings.desktop
cp $HOME/dotfiles/apps/ml4w-dotfiles-settings.desktop $HOME/.local/share/applications
echo ":: ML4W Dotfiles Settings App installed successfully"

echo 