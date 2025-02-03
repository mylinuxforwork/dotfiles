# ------------------------------------------------------
# Remove packages
# ------------------------------------------------------
_writeLogHeader "Remove old packages"

# Remove aylurs-gtk-shell
if [[ $(_isInstalled "aylurs-gtk-shell-git") == 0 ]]; then
    $aur_helper --noconfirm -R aylurs-gtk-shell-git
    echo ":: aylurs-gtk-shell-git removed"
    echo
fi

# Remove bibata-cursor-theme
if [ $install_platform == "arch" ]; then
    if [[ $(_isInstalled "bibata-cursor-theme") == 0 ]]; then
        _removePackage "bibata-cursor-theme"
        echo ":: bibata-cursor-theme removed"
        echo
    fi
fi

# Remove rofi-lbonn-wayland
_writeLog 0 "Checking for rofi-lbonn-wayland"
if [[ $(_isInstalled "rofi-lbonn-wayland") == 0 ]]; then
    _removePackage "rofi-lbonn-wayland"
    _writeLog 1 "rofi-lbonn-wayland removed"
    echo
fi

# Remove hypridle-bin
_writeLog 0 "Checking for hypridle-git"
if [[ $(_isInstalled "hypridle-git") == 0 ]]; then
    _removePackage "hypridle-git"
    if [ -f /usr/lib/debug/usr/bin/hypridle.debug ]; then
        sudo rm /usr/lib/debug/usr/bin/hypridle.debug
    _writeLog 1 "/usr/lib/debug/usr/bin/hypridle.debug removed"
    fi
    _writeLog 1 "hypridle-git uninstalled."
    _writeLog 1 "hypridle can now be installed."
    echo 
fi

# Remove hyprlock-bin
_writeLog 0 "Checking for hyprlock-git"
if [[ $(_isInstalled "hyprlock-git") == 0 ]]; then
    _removePackage "hyprlock-git"
    if [ -f /usr/lib/debug/usr/bin/hyprlock.debug ]; then
        sudo rm /usr/lib/debug/usr/bin/hyprlock.debug
        echo ":: /usr/lib/debug/usr/bin/hyprlock.debug removed"
    fi
    _writeLog 1 "hyprlock-git uninstalled."
    _writeLog 1 "hyprlock can now be installed."
    echo
fi

# Remove bibata-cursor-theme
_writeLog 0 "Checking for bibata-cursor-theme"
if [[ $(_isInstalled "bibata-cursor-theme") == 0 ]]; then
    _removePackage "bibata-cursor-theme"
    _writeLog 1 "bibata-cursor-theme removed"
    echo
fi
