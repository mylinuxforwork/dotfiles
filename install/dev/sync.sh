#!/bin/bash
# Execute the script with ./sync version e.g., ./sync 2.5.2

if [ ! -z $1 ] ;then
    if [ -d ~/.ml4w-dotfiles/"$1" ] ;then
        echo "Folder exists. Start rsync now ..."
        rsync -avhp -I --exclude-from=$HOME/.ml4w-dotfiles/$1/install/dev/excludes.txt ~/.ml4w-dotfiles/dotfiles/dotfiles/  ~/dotfiles
    else 
        echo "Folder ~/.ml4w-dotfiles/$1 not found."
    fi
else
    echo "No folder specified. Please use ./sync folder"
fi