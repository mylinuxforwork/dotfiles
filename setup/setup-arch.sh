#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --------------------------------------------------------------
# General Packages
# --------------------------------------------------------------

source pkgs.sh

# --------------------------------------------------------------
# Distro related packages
# --------------------------------------------------------------

packages=(
    # Hyprland
    "hyprland"
    "libnotify"
    "qt5-wayland"
    "qt6-wayland"
    "uwsm"
    "python-pip"
    "python-gobject"
    "python-screeninfo"
    "nm-connection-editor"
    "network-manager-applet"
    "imagemagick"
    "polkit-gnome"
    "hyprshade"
    "grimblast-git"
    "checkupdates-with-aur"
    "loupe"
    "power-profiles-daemon"
    # Apps
    "pacseek"
    "waypaper"
    "swaync"
    # Tools
    "eza"
    "python-pywalfox"
    # Themes
    "bibata-cursor-theme-bin"
    "papirus-icon-theme"
    "breeze"
    # Fonts
    "otf-font-awesome"
    "ttf-fira-sans"
    "ttf-fira-code"
    "ttf-firacode-nerd"
    "ttf-dejavu"
    "noto-fonts"
    "noto-fonts-emoji"
    "noto-fonts-cjk"
    "noto-fonts-extra"
)

GREEN='\033[0;32m'
NONE='\033[0m'

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
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay-bin.git $HOME/Downloads/yay-bin
    cd $HOME/Downloads/yay-bin
    makepkg -si
    cd $temp_path
    echo ":: yay has been installed successfully."
}

_installPackages() {
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi
        yay --noconfirm -S "${pkg}"
    done
}

# --------------------------------------------------------------
# Install Gum
# --------------------------------------------------------------

if [[ $(_checkCommandExists "gum") == 0 ]]; then
    echo ":: gum is already installed"
else
    echo ":: The installer requires gum. gum will be installed now"
    sudo pacman --noconfirm -S gum
fi

# --------------------------------------------------------------
# Header
# --------------------------------------------------------------

clear
echo -e "${GREEN}"
cat <<"EOF"
   ____    __          
  / __/__ / /___ _____ 
 _\ \/ -_) __/ // / _ \
/___/\__/\__/\_,_/ .__/
                /_/    
EOF
echo "ML4W Dotfiles for Hyprland for Arch"
echo -e "${NONE}"
if gum confirm "DO YOU WANT TO START THE SETUP NOW?: "; then
    echo ":: Installation started."
    echo
else
    echo ":: Installation canceled"
    exit
fi

# --------------------------------------------------------------
# Install yay if needed
# --------------------------------------------------------------

if [[ $(_checkCommandExists "yay") == 0 ]]; then
    echo ":: yay is already installed"
else
    echo ":: The installer requires yay. yay will be installed now"
    _installYay
fi

# --------------------------------------------------------------
# General
# --------------------------------------------------------------

_installPackages "${general[@]}"

# --------------------------------------------------------------
# Apps
# --------------------------------------------------------------

_installPackages "${apps[@]}"

# --------------------------------------------------------------
# Tools
# --------------------------------------------------------------

_installPackages "${tools[@]}"

# --------------------------------------------------------------
# Packages
# --------------------------------------------------------------

_installPackages "${packages[@]}"

# --------------------------------------------------------------
# Hyprland
# --------------------------------------------------------------

_installPackages "${hyprland[@]}"

# --------------------------------------------------------------
# Create .local/bin folder
# --------------------------------------------------------------

if [ ! -d $HOME/.local/bin ]; then
    mkdir -p $HOME/.local/bin
fi

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# Prebuild Packages
# --------------------------------------------------------------

echo "Installing Matugen v2.4.1 into ~/.local/bin"
# https://github.com/InioX/matugen/releases
cp $SCRIPT_DIR/packages/matugen $HOME/.local/bin

echo "Installing Wallust v3.4.0 into ~/.local/bin"
# https://codeberg.org/explosion-mental/wallust/releases
cp $SCRIPT_DIR/packages/wallust $HOME/.local/bin

# --------------------------------------------------------------
# ML4W Apps
# --------------------------------------------------------------

echo ":: Installing the ML4W Apps"

ml4w_app="com.ml4w.welcome"
ml4w_app_repo="dotfiles-welcome"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

ml4w_app="com.ml4w.settings"
ml4w_app_repo="dotfiles-settings"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

ml4w_app="com.ml4w.sidebar"
ml4w_app_repo="dotfiles-sidebar"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

ml4w_app="com.ml4w.calendar"
ml4w_app_repo="dotfiles-calendar"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

ml4w_app="com.ml4w.hyprlandsettings"
ml4w_app_repo="hyprland-settings"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

# --------------------------------------------------------------
# Flatpaks
# --------------------------------------------------------------

flatpak install -y flathub com.github.PintaProject.Pinta

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

sudo cp -rf $SCRIPT_DIR/fonts/FiraCode /usr/share/fonts
sudo cp -rf $SCRIPT_DIR/fonts/Fira_Sans /usr/share/fonts

echo ":: Installation complete."
echo ":: Ready to install the dotfiles with the Dotfiles Installer."