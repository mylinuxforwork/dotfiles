#!/bin/bash
clear
sleep 1
figlet "Update"
echo
if gum confirm "Do you want to start the update now?" ;then

    # Remove existing download folder 
    if [ -d $HOME/Downloads/dotfiles ] ;then
        rm -rf $HOME/Downloads/dotfiles
    fi
    if [ -d $HOME/Downloads/dotfiles-main ] ;then
        rm -rf $HOME/Downloads/dotfiles-main
    fi
    if [ -d $HOME/Downloads/dotfiles-dev ] ;then
        rm -rf $HOME/Downloads/dotfiles-dev
    fi

    echo "Please choose between the main-release or the rolling-release:"
    version=$(gum choose "main-release" "rolling-release")
    if [ "$version" == "main-release" ] ;then
    # Download dotfiles zip into ~/Downloads
        wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/dotfiles/-/archive/main/dotfiles-main.zip
        v="main"
    elif [ "$version" == "rolling-release" ] ;then
        wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/dotfiles/-/archive/dev/dotfiles-dev.zip
        v="dev"
    else
        exit 130
    fi
    echo ":: Download complete."
    echo ""

    # Unzip
    unzip -o ~/Downloads/dotfiles-$v.zip -d ~/Downloads/
    echo ":: Unzip complete."
    cd ~/Downloads/dotfiles-$v/

    # Start the installatiom
    if gum confirm "Do you want to start the update now?" ;then
        echo "Starting the installation now..."
        sleep 2
        cd $HOME/Downloads/dotfiles-$v
        ./install.sh
    elif [ $? -eq 130 ]; then
            exit 130
    else
        echo "Installation canceled."
        echo "You can start the installation manually with ~/Downloads/dotfiles-$version/install.sh"
        exit;
    fi
elif [ $? -eq 130 ]; then
    exit 130
fi