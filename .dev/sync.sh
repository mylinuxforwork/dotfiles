#!/bin/bash
# Execute the script with ./sync version e.g., ./sync 2.5.2

if [ ! -z $1 ] ;then
    if [ -d ~/dotfiles-versions/"$1" ] ;then
        echo "Folder exists. Start rsync now ..."
        rsync -avhp -I --exclude-from=excludes.txt ~/dotfiles-versions/$1/  ~/dotfiles
    else 
        echo "Folder ~/dotfiles-versions/$1 not found."
    fi
else
    echo "No folder specified. Please use ./sync folder"
fi