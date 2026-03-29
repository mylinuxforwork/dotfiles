#!/usr/bin/env bash

yay_installed="false"
paru_installed="false"
aur_helper=""

_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi
    echo 0
    return
}

_isInstalled() {
    package="$1"
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0
        return #true
    fi
    echo 1
    return #false
}

_installYay() {
    if [[ ! $(_isInstalled "base-devel") == 0 ]]; then
        sudo pacman --noconfirm -S "base-devel"
    fi
    if [[ ! $(_isInstalled "git") == 0 ]]; then
        sudo pacman --noconfirm -S "git"
    fi
    if [ -d $HOME/Downloads/yay-bin ]; then
        rm -rf $HOME/Downloads/yay-bin
    fi
    git clone https://aur.archlinux.org/yay-bin.git $HOME/Downloads/yay-bin
    (cd "$HOME/Downloads/yay-bin" && makepkg -si --noconfirm) 
    echo ":: yay has been installed successfully."
}

_installParu() {
    if [[ ! $(_isInstalled "base-devel") == 0 ]]; then
        sudo pacman --noconfirm -S "base-devel"
    fi
    if [[ ! $(_isInstalled "git") == 0 ]]; then
        sudo pacman --noconfirm -S "git"
    fi
    if [ -d $HOME/Downloads/paru ]; then
        rm -rf $HOME/Downloads/paru
    fi
    git clone https://aur.archlinux.org/paru.git $HOME/Downloads/paru
    (cd "$HOME/Downloads/paru" && makepkg -si --noconfirm)
    echo ":: paru has been installed successfully."
}

_selectAURHelper() {
    echo ":: Please select your preferred AUR Helper"
    echo
    aur_helper=$(gum choose "yay" "paru")
    if [ -z $aur_helper ]; then
        _selectAURHelper
    fi
    echo ":: Using $aur_helper as AUR Helper"
}

_checkAURHelper() {
    if [[ $(_checkCommandExists "yay") == 0 ]]; then
        echo ":: yay is installed"
        yay_installed="true"
    fi
    if [[ $(_checkCommandExists "paru") == 0 ]]; then
        echo ":: paru is installed"
        paru_installed="true"
    fi
    if [[ $yay_installed == "true" ]] && [[ $paru_installed == "false" ]]; then
        echo ":: Using AUR Helper yay"
        aur_helper="yay"
    elif [[ $yay_installed == "false" ]] && [[ $paru_installed == "true" ]]; then
        echo ":: Using AUR Helper paru"
        aur_helper="paru"
    elif [[ $yay_installed == "false" ]] && [[ $paru_installed == "false" ]]; then
        echo ":: No AUR Helper installed"
        _selectAURHelper
        if [[ $aur_helper == "yay" ]]; then
            _installYay
        else
            _installParu
        fi
    else
        _selectAURHelper
    fi
}

# --------------------------------------------------------------
# AUR Helper
# --------------------------------------------------------------
_checkAURHelper

# --------------------------------------------------------------
# Uninstall swww if exists. To be replaced with awww in the next steps
# --------------------------------------------------------------

if command -v swww &> /dev/null || pacman -Qq swww &> /dev/null; then
    sudo pacman -Rns --noconfirm swww
fi