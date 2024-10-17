# ------------------------------------------------------
# Select AUR Helper
# ------------------------------------------------------

aur_helper=""

_selectAURHelper() {
    echo ":: Please select your preferred AUR Helper"
    echo
    aur_helper=$(gum choose "yay" "paru" "pikaur" "trizen" "aurman" "pacaur" "pakku")
    if [ -z $aur_helper ] ;then
        _selectAURHelper
    fi
    if command -v "$aur_helper" &> /dev/null; then
        echo ":: $aur_helper is already installed."
        return 0
    else
        echo ":: Installing $aur_helper..."
        cd $HOME
        if [ -d "$HOME/$aur_helper" ]; then
            rm -rf "$HOME/$aur_helper"
        fi
        git clone "https://aur.archlinux.org/$aur_helper.git" ~/$aur_helper || { echo ":: Failed to clone $aur_helper."; return 1; }
        cd $HOME/"$aur_helper" || { echo ":: Failed to change directory to $aur_helper."; return 1; }
        makepkg -si --noconfirm || { echo ":: Installation of $aur_helper failed."; return 1; }
        cd $HOME
        rm -rf "$aur_helper"
        echo ":: $aur_helper installed successfully."
    fi
}

echo -e "${GREEN}"
figlet -f smslant "AUR Helper"
echo -e "${NONE}"

_selectAURHelper