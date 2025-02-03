# ------------------------------------------------------
# Check if yay is installed
# ------------------------------------------------------

if [ $install_platform = "arch" ]; then
_writeLogHeader "AUR"

yay_installed="false"
paru_installed="false"
aur_helper=""

_installYay() {
    _installPackages "base-devel"
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay.git $download_folder/yay
    cd $download_folder/yay
    makepkg -si
    cd $temp_path
    _writeLogTerminal 1 "yay has been installed successfully."
}

_installParu() {
    _installPackages "base-devel"
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/paru.git $download_folder/paru
    cd $download_folder/paru
    makepkg -si
    cd $temp_path
    _writeLogTerminal 1 "paru has been installed successfully."
}

_selectAURHelper() {
    _writeHeader "AUR Helper"
    _writeMessage "Please select your preferred AUR Helper"
    echo
    aur_helper=$(gum choose "yay" "paru")
    if [ -z $aur_helper ]; then
        _selectAURHelper
    fi
    _writeLogTerminal 0 "Using $aur_helper as AUR Helper"
}

_checkAURHelper() {
    if _checkCommandExists "yay"; then
        _writeLog 0 "yay is installed"
        yay_installed="true"
    fi
    if _checkCommandExists "paru"; then
        _writeLog 0 "paru is installed"
        paru_installed="true"
    fi
    if [[ $yay_installed == "true" ]] && [[ $paru_installed == "false" ]]; then
        _writeLog 0 "Using AUR Helper yay"
        aur_helper="yay"
    elif [[ $yay_installed == "false" ]] && [[ $paru_installed == "true" ]]; then
        _writeLog 0 "Using AUR Helper paru"
        aur_helper="paru"
    elif [[ $yay_installed == "false" ]] && [[ $paru_installed == "false" ]]; then
        if [[ $(_check_update) == "false" ]]; then
            _selectAURHelper
            if [[ $aur_helper == "yay" ]]; then
                _installYay
            else
                _installParu
            fi
        fi
    else
        _selectAURHelper
    fi
}

if [ ! -z $automation_aur ]; then
    aur_helper=$automation_aur
    _writeLogTerminal 0 "AUTOMATION: Using $aur_helper as AUR helper"
else
    _checkAURHelper
fi

fi
