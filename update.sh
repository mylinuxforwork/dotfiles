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
    echo "Please choose between the main-release or the rolling-release (development version):"
    version=$(gum choose "main-release" "rolling-release")
    if [ "$version" == "main-release" ] ;then
        wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/dotfiles/-/archive/main/dotfiles-main.zip
        v="main"
    elif [ "$version" == "rolling-release" ] ;then
        wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/dotfiles/-/archive/dev/dotfiles-dev.zip
        v="dev"
    else
        exit 130
    fi
    echo ":: Download complete."

    # Unzip
    unzip -o -q ~/Downloads/dotfiles-$v.zip -d ~/Downloads/
    echo ":: Unzip complete."
    cd ~/Downloads/dotfiles-$v/
    echo ":: Changed into ~/Downloads/dotfiles-$v/"
    
    # Start the installatiom
    if gum confirm "Do you want to start the update now?" ;then
        gum spin --spinner dot --title "Starting the update now..." -- sleep 3
        cd $HOME/Downloads/dotfiles-$v
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