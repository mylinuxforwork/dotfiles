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
    "hyprland-devel"
    "hyprland-qtutils"
    # Tools
    "eza"
    "libnotify-tools"
    "libqt5-qtwayland"
    "qt6-wayland"
    "python313-pipx"
    "ImageMagick"
    "NetworkManager-connection-editor"
    "NetworkManager-tui"
    # Apps
    "SwayNotificationCenter"
    # Themes
    "papirus-icon-theme"
    "breeze"
    # Fonts
    "mozilla-fira-sans-fonts"
    "fira-code-fonts"
    "google-noto-fonts"
    "google-noto-emoji-fonts"
    "fontawesome-fonts"
    "dejavu-fonts"
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
    package_info=$(zypper se -i "$package" 2>/dev/null | grep "^i" | awk '{print $3}')
    ret=1
    for pkg in $package_info
    do
	if [ "$package" == "$pkg" ]; then
		ret=0
		break
	fi
	done
	echo $ret
}

_installPackages() {
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed."
            continue
        fi
        sudo zypper -n install "${pkg}"
    done
}

# --------------------------------------------------------------
# Install Gum
# --------------------------------------------------------------

if [[ $(_checkCommandExists "gum") == 0 ]]; then
    echo ":: gum is already installed"
else
    echo ":: The installer requires gum. gum will be installed now"
    sudo zypper -n install gum
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
echo "ML4W Dotfiles for Hyprland for openSuse Tumbleweed"
echo -e "${NONE}"
if gum confirm "DO YOU WANT TO START THE SETUP NOW?: "; then
    echo ":: Installation started."
    echo
else
    echo ":: Installation canceled"
    exit
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
# Snap
# --------------------------------------------------------------

sudo zypper addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
sudo zypper --gpg-auto-import-keys refresh
sudo zypper dup --from snappy
sudo zypper install snapd
sudo systemctl enable snapd
sudo systemctl start snapd
sudo systemctl enable snapd.apparmor
sudo systemctl start snapd.apparmor

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

echo "Installing eza"
sudo zypper ar https://download.opensuse.org/tumbleweed/repo/oss/ factory-oss
sudo zypper -n install eza

# --------------------------------------------------------------
# Install waypaper dependencies before using pip
# --------------------------------------------------------------

sudo zypper install gcc pkg-config cairo-devel gobject-introspection-devel libgirepository-1_0-1-devel python3-devel libgtk-4-devel typelib-1_0-Gtk-4_0

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

echo ":: Installing packages with pip"
sudo pipx install hyprshade
sudo pipx install pywalfox
sudo pywalfox install
sudo pipx install screeninfo
sudo pipx install waypaper

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
# Grimblast
# --------------------------------------------------------------

sudo cp $SCRIPT_DIR/scripts/grimblast /usr/bin

# --------------------------------------------------------------
# Bibata Cursor Theme
# --------------------------------------------------------------

sudo snap install cursor-theme-bibata

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

sudo cp -rf $SCRIPT_DIR/fonts/FiraCode /usr/share/fonts
sudo cp -rf $SCRIPT_DIR/fonts/Fira_Sans /usr/share/fonts

echo ":: Installation complete."
echo ":: Ready to install the dotfiles with the Dotfiles Installer."