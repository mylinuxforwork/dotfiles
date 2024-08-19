#!/bin/bash
# Execute the script with ./sync version e.g., ./sync 2.5.2

if [ ! -z $1 ] ;then
    if [ -d ~/$ml4w_directory/"$1" ] ;then
        echo "Folder exists. Start rsync now ..."
        rsync -avhp -I --exclude-from=$HOME/$ml4w_directory/$1/install/dev/excludes.txt ~/$ml4w_directory/dotfiles/dotfiles/  ~/dotfiles
    else 
        echo "Folder ~/$ml4w_directory/$1 not found."
    fi
else
    echo "No folder specified. Please use ./sync folder"
fi