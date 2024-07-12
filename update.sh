#!/bin/bash
#  _   _           _       _       
# | | | |_ __   __| | __ _| |_ ___ 
# | | | | '_ \ / _` |/ _` | __/ _ \
# | |_| | |_) | (_| | (_| | ||  __/
#  \___/| .__/ \__,_|\__,_|\__\___|
#       |_|                        
# 
clear
sleep 1
figlet "Update"
if [ ! -d $HOME/Downloads ] ;then
    echo "ERROR:: $HOME/Downloads folder not found."
    exit
fi
echo
if gum confirm "Do you want to start the update now?" ;then

    # Remove existing download folder and zip files 
    if [ -f $HOME/Downloads/dotfiles-main.zip ] ;then
        rm $HOME/Downloads/dotfiles-main.zip
    fi
    if [ -f $HOME/Downloads/dotfiles-dev.zip ] ;then
        rm $HOME/Downloads/dotfiles-dev.zip
    fi
    if [ -f $HOME/Downloads/dotfiles.zip ] ;then
        rm $HOME/Downloads/dotfiles.zip
    fi
    if [ -d $HOME/Downloads/dotfiles ] ;then
        rm -rf $HOME/Downloads/dotfiles
    fi
    if [ -d $HOME/Downloads/dotfiles-main ] ;then
        rm -rf $HOME/Downloads/dotfiles-main
    fi
    if [ -d $HOME/Downloads/dotfiles-dev ] ;then
        rm -rf $HOME/Downloads/dotfiles-dev
    fi
    echo 

    # Change into Downloads Directory
    cd ~/Downloads

    # Select the dotfiles version
    echo "Please choose between the main-release or the rolling-release (development version):"
    version=$(gum choose "main-release" "rolling-release")
    if [ "$version" == "main-release" ] ;then
        git clone -b main --single-branch --depth 1 https://gitlab.com/stephan-raabe/dotfiles.git
    elif [ "$version" == "rolling-release" ] ;then
        git clone -b dev --single-branch --depth 1 https://gitlab.com/stephan-raabe/dotfiles.git
    else
        exit 130
    fi
    echo ":: Download complete."
    echo 
    # Start the installatiom
    if gum confirm "Do you want to start the update now?" ;then

        # Change into dotfiles folder
        cd $HOME/Downloads/dotfiles/
        echo ":: Changed into ~/Downloads/dotfiles/"

        # Start Spinner
        gum spin --spinner dot --title "Starting the update now..." -- sleep 3
        ./install.sh

    elif [ $? -eq 130 ]; then
            exit 130
    else
        echo "Installation canceled."
        exit;
    fi
elif [ $? -eq 130 ]; then
    exit 130
fi