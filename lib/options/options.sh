#!/bin/bash
sleep 1

_checkPackages() {
    for pkg in ${optdepends[@]}; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
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

_checkSddm() {
    if [ -f /etc/systemd/system/display-manager.service ]; then
        echo "Enabled"
    else
        echo "Not enabled"
    fi
}

_checkSddmTheme() {
    if [ -d /usr/share/sddm/themes/sequoia ]; then
        echo "Installed"
    else
        echo "Not installed"
    fi
}

_checkPywalfox() {
    if [[ $(_isInstalled "python-pywalfox") == 0 ]]; then
        echo "Installed"
    else
        echo "Not installed"
    fi
}

_selectCategory() {
    clear
    echo -e "${GREEN}"
    figlet -f smslant "Options"
    echo -e "${NONE}"
    echo "Platform: $install_platform"
    echo "This script will help you to install some pre-defined package options."
    echo "If your desired package is not listed, you can install it with your package manager "
    echo "and set it as default application in the ML4W Settings App."
    if [[ ! $(_isInstalled "xdg-desktop-portal-gtk") == 0 ]]; then
        echo "Please note: xdg-desktop-portal-gtk is required to get dark theme on GTK apps."
    fi
    echo
    if [[ ! $(_isInstalled "xdg-desktop-portal-gtk") == 0 ]]; then
        echo "- xdg-desktop-portal-gtk: Not installed"
    else
        echo "- xdg-desktop-portal-gtk: Installed"
    fi
    echo "- SDDM:" $(_checkSddm) "/ SDDM Theme:" $(_checkSddmTheme)    
    echo "- Shell: "$SHELL "/ Terminal:" $(_checkCurrent terminal.sh)
    echo "- File manager:" $(_checkCurrent filemanager.sh) 
    echo "- Browser:" $(_checkCurrent browser.sh) 
    echo "- System monitor:" $(_checkCurrent system-monitor.sh)     
    echo
    if [[ ! $(_isInstalled "xdg-desktop-portal-gtk") == 0 ]]; then
        category=$(gum choose "xdg-desktop-portal-gtk" "shell" "terminal" "file manager" "browser" "pywalfox" "system monitor" "sddm theme" "more" "REBOOT" "CANCEL")
    else
        category=$(gum choose "shell" "terminal" "file manager" "browser" "pywalfox" "system monitor" "sddm theme" "more" "REBOOT" "CANCEL")
    fi
    case ${category} in
        xdg-desktop-portal-gtk)
            source $options_directory/options/xdg-desktop-portal-gtk.sh
        ;;
        terminal)
            source $options_directory/options/terminal.sh
        ;;
        "file manager")
            source $options_directory/options/filemanager.sh
        ;;
        "system monitor")
            source $options_directory/options/system-monitor.sh
        ;;
        browser)
            source $options_directory/options/browser.sh
        ;;
        more)
            source $options_directory/options/other.sh
        ;;
        shell)
            source $options_directory/options/shell.sh
        ;;
        "sddm theme")
            source $options_directory/options/sddm-theme.sh
        ;;
        pywalfox)
            source $options_directory/options/pywalfox.sh
        ;;
        REBOOT)
            reboot
        ;;
        CANCEL)
            exit
        ;;
        *)
            exit
        ;;
    esac
}

_selectCategory