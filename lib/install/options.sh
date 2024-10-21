#!/bin/bash
aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"
sleep 1

_checkPackages() {
    for pkg in ${optdepends[@]}; do
        if [[ $(_isInstalledAUR "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
        fi
        toInstall+="${pkg} "
    done
    echo
}

_checkDefault() {
    if [ -f ~/.config/ml4w/settings/$1 ]; then
        default="$(cat ~/.config/ml4w/settings/$1)"
        echo ":: Current setup: $default"
    else
        echo ":: ERROR: No configuration file found"
    fi
    echo
}

_checkCurrent() {
    if [ -f ~/.config/ml4w/settings/$1 ]; then
        default="$(cat ~/.config/ml4w/settings/$1)"
        echo $default
    else
        echo "No configuration file found"
    fi
}

_selectCategory() {
    clear
    echo -e "${GREEN}"
    figlet -f smslant "Options"
    echo -e "${NONE}"
    echo "This script will help you to install some pre-defined package options."
    echo "If your desired package is not listed, you can install it with yay -S package "
    echo "and set it as default application in the ML4W Settings App."
    if [[ ! $(_isInstalledAUR "xdg-desktop-portal-gtk") == 0 ]]; then
        echo "Please note: xdg-desktop-portal-gtk is required to get dark theme on GTK apps."
    fi
    echo
    echo "Current configuration:"
    if [[ ! $(_isInstalledAUR "xdg-desktop-portal-gtk") == 0 ]]; then
    echo "- Shell: " $SHELL 
    echo "- Terminal:" $(_checkCurrent terminal.sh)     
    echo "- File manager:" $(_checkCurrent filemanager.sh) 
    echo "- Browser:" $(_checkCurrent browser.sh) 
    echo "- System monitor:" $(_checkCurrent system-monitor.sh)     
    echo
    echo "Please choose a category to change it:"
    echo
    if [[ ! $(_isInstalledAUR "xdg-desktop-portal-gtk") == 0 ]]; then
        category=$(gum choose "xdg-desktop-portal-gtk" "shell" "terminal" "file manager" "browser" "CANCEL")
    else
        category=$(gum choose "shell" "terminal" "file manager" "browser" "CANCEL")
    fi
    case ${category} in
        xdg-desktop-portal-gtk)
            source $install_directory/options/xdg-desktop-portal-gtk.sh
        ;;
        terminal)
            source $install_directory/options/terminal.sh
        ;;
        "file manager")
            source $install_directory/options/filemanager.sh
        ;;
        browser)
            source $install_directory/options/browser.sh
        ;;
        shell)
            source $install_directory/options/shell.sh
        ;;
        CANCEL)
            exit
        ;;
    esac
}

_selectCategory