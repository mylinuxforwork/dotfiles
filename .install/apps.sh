#!/bin/bash

# ------------------------------------------------------
# Apps Installation
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "ML4W Apps"
echo -e "${NONE}"

sed -i "s|HOME|${HOME}|g" $HOME/dotfiles/apps/ml4w-welcome.desktop
cp $HOME/dotfiles/apps/ml4w-welcome.desktop $HOME/.local/share/applications
echo ":: ML4W Welcome App installed successfully"
echo 