# ------------------------------------------------------
# Remove packages
# ------------------------------------------------------
_writeLogHeader "Remove old packages"

# Remove Rofi Calc
_writeLog 0 "Checking for rofi-calc"
if [[ $(_isInstalled "rofi-calc") == 0 ]]; then
    _removePackage "rofi-calc"
    _writeLog 1 "rofi-calc removed"
    echo
fi

# Remove Rofi
_writeLog 0 "Checking for rofi"
if [[ $(_isInstalled "rofi") == 0 ]]; then
    _removePackage "rofi"
    _writeLog 1 "rofi removed"
    echo
fi

# Remove Swayidle
_writeLog 0 "Checking for swayidle"
if [[ $(_isInstalled "swayidle") == 0 ]]; then
    _removePackage "swayidle"
   _writeLog 1 "swayidle removed"
    echo
fi

# Remove Swaylock
if [[ $(_isInstalled "swaylock-effects-git") == 0 ]]; then
    $aur_helper --noconfirm -R swaylock-effects-git
    echo ":: swaylock removed"
    echo
fi

# Remove aylurs-gtk-shell
if [[ $(_isInstalled "aylurs-gtk-shell-git") == 0 ]]; then
    $aur_helper --noconfirm -R aylurs-gtk-shell-git
    echo ":: aylurs-gtk-shell-git removed"
    echo
fi

# Remove bibata-cursor-theme
if [[ $(_isInstalled "bibata-cursor-theme") == 0 ]]; then
    $aur_helper --noconfirm -R bibata-cursor-theme
    echo ":: bibata-cursor-theme removed"
    echo
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
    if [ -f /usr/lib/debug/usr/bin/hypridle.debug ] ;then
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
    if [ -f /usr/lib/debug/usr/bin/hyprlock.debug ] ;then
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
