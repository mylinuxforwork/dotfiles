#!/bin/bash
#     _        _   _            _
#    / \   ___| |_(_)_   ____ _| |_ ___
#   / _ \ / __| __| \ \ / / _` | __/ _ \
#  / ___ \ (__| |_| |\ V / (_| | ||  __/
# /_/   \_\___|\__|_| \_/ \__,_|\__\___|
#

clear
dot_folder=""

_activate_dotfiles_folder() {
    echo ":: Activating $dot_folder now..."
    echo

    # Check home
    files=$(ls -a $HOME/$dot_folder)
    for f in $files; do
        if [ ! "$f" == "." ] && [ ! "$f" == ".." ] && [ ! "$f" == ".config" ]; then
            if [ -f $HOME/$dot_folder/$f ]; then
                # echo ":: Checking for file $HOME/$f"
                if [ -L $HOME/$f ]; then
                    rm $HOME/$f
                fi
                if [ -f ~/$f ]; then
                    rm $HOME/$f
                fi
                ln -s $HOME/$dot_folder/$f $HOME
                if [ -L $HOME/$f ]; then
                    echo ":: SUCCESS $HOME/$dot_folder/$f -> $HOME/$f"
                else
                    echo ":: ERROR $HOME/$dot_folder/$f -> $HOME/$f"
                fi
            fi
        fi
    done

    # Check .config
    files=$(ls -a $HOME/$dot_folder/.config)
    for f in $files; do
        if [ ! "$f" == "." ] && [ ! "$f" == ".." ]; then
            if [ -d $HOME/$dot_folder/.config/$f ]; then
                # echo ":: Checking for directory $HOME/.config/$f"
                if [ -L $HOME/.config/$f ]; then
                    rm $HOME/.config/$f
                fi
                if [ -f $HOME/.config/$f ]; then
                    rm $HOME/.config/$f
                fi
                if [ -d $HOME/.config/$f ]; then
                    rm -rf $HOME/.config/$f
                fi
                ln -s $HOME/$dot_folder/.config/$f $HOME/.config
                if [ -L $HOME/.config/$f ]; then
                    echo ":: SUCCESS $HOME/$dot_folder/.config/$f -> $HOME/.config/$f"
                else
                    echo ":: ERROR $HOME/$dot_folder/.config/$f -> $HOME/.config/$f"
                fi
            fi
            if [ -f $HOME/$dot_folder/.config/$f ]; then
                # echo ":: Checking for file $HOME/.config/$f"
                if [ -L $HOME/.config/$f ]; then
                    rm $HOME/.config/$f
                fi
                if [ -f $HOME/.config/$f ]; then
                    rm $HOME/.config/$f
                fi
                ln -s $HOME/$dot_folder/.config/$f $HOME/.config
                if [ -L $HOME/.config/$f ]; then
                    echo ":: SUCCESS $HOME/$dot_folder/.config/$f -> $HOME/.config/$f"
                else
                    echo ":: ERROR $HOME/$dot_folder/.config/$f -> $HOME/.config/$f"
                fi
            fi
        fi
    done

    # Write dot folder into settings
    echo "$dot_folder" >$HOME/$dot_folder/.config/ml4w/settings/dotfiles-folder.sh

    stow --dir="$HOME/$dot_folder" --target="$HOME" .
    echo
    echo ":: Activation of ~/$dot_folder completed. "
    echo
    echo -e "${GREEN}"
    figlet -f smslant "Logout"
    echo -e "${NONE}"
    echo "A new login into your system is recommended."
    echo
    if gum confirm "Do you want to exit your system now?"; then
        gum spin --spinner dot --title "Logout has started..." -- sleep 3
        killall -9 Hyprland
    elif [ $? -eq 130 ]; then
        exit 130
    else
        _writeSkipped
    fi
    echo ""

    echo

    exit
}

_define_dotfiles_folder() {
    dot_folder_tmp=$(gum input --value "$dot_folder" --placeholder "Enter your installation folder name")
    dot_folder=${dot_folder_tmp//[[:blank:]]/}
    if [ $dot_folder == "cancel" ]; then
        exit
    elif [ $dot_folder == ".ml4w-hyprland" ]; then
        echo ":: The folder .ml4w-hyprland is not allowed."
        _define_dotfiles_folder
    else
        _confirm_dotfiles_folder
    fi
}

_confirm_dotfiles_folder() {
    if [ -d ~/$dot_folder ] && [ -d ~/$dot_folder/.config/ml4w ]; then
        echo ":: ML4W Dotfiles folder ~/$dot_folder selected."
        echo
        if gum confirm "Do you want to activate now?"; then
            _activate_dotfiles_folder
        else
            _writeCancel
            exit
        fi
    else
        echo "ERROR: The folder doesn't exits or isn't a compatible ML4W Dotfiles installation."
        echo "Please update the folder name!"
        echo
        _define_dotfiles_folder
    fi
}

figlet -f smslant "Activate"
echo ":: You can activate an exiting ML4W Dotfiles installation."
echo
echo ":: Please enter the name of the installation folder starting from your home directory."
echo ":: (e.g., dotfiles or Documents/mydotfiles, ...)"
echo ":: Enter cancel to exit"
echo
_define_dotfiles_folder
