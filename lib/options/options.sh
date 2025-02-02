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

_handleCategorySelection() {
    case $1 in
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

_selectCategory() {
    if [[ -n "$options_argument" ]]; then
        echo "Options argument: $options_argument"
        _handleCategorySelection "$options_argument"
        exit
    fi

    clear
    echo -e "${GREEN}"
    figlet -f smslant "Options"
    echo -e "${NONE}"
    echo "Platform: $install_platform"
    echo "This script will help you to install some pre-defined package options."
    echo "If your desired package is not listed, you can install it with your package manager "
    echo "and set it as default application in the ML4W Settings App."
    echo
    echo "- SDDM:" $(_checkSddm) "/ SDDM Theme:" $(_checkSddmTheme)    
    echo "- Shell: "$SHELL "/ Terminal:" $(_checkCurrent terminal.sh)
    echo "- File manager:" $(_checkCurrent filemanager.sh) 
    echo "- Browser:" $(_checkCurrent browser.sh) 
    echo "- System monitor:" $(_checkCurrent system-monitor.sh)     
    echo
    category=$(gum choose "shell" "terminal" "file manager" "browser" "pywalfox" "system monitor" "more" "REBOOT" "CANCEL")
    _handleCategorySelection "$category"
}

_selectCategory