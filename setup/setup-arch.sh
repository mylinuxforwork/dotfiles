#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

packages=(
    "wget"
    "unzip"
    "gum"
    "rsync"
    "git"
    "figlet"
    "xdg-user-dirs"    
    "hyprland"
    "hyprpaper"
    "hyprlock"
    "hypridle"
    "hyprpicker"
    "noto-fonts"
    "noto-fonts-emoji"
    "noto-fonts-cjk"
    "noto-fonts-extra"
    "xdg-desktop-portal-hyprland"
    "libnotify"
    "kitty"
    "qt5-wayland"
    "qt6-wayland"
    "uwsm"
    "fastfetch"
    "xdg-desktop-portal-gtk"
    "eza"
    "nautilus"
    "python-pip"
    "python-gobject"
    "python-screeninfo"
    "tumbler"
    "brightnessctl"
    "nm-connection-editor"
    "network-manager-applet"
    "gtk4"
    "libadwaita"
    "fuse2"
    "imagemagick"
    "jq"
    "xclip"
    "kitty"
    "neovim"
    "htop"
    "rust"
    "cargo"
    "blueman"
    "grim"
    "slurp"
    "cliphist"
    "nwg-look"
    "qt6ct"
    "waybar"
    "rofi-wayland"
    "polkit-gnome"
    "zsh"
    "fzf"
    "pavucontrol"
    "papirus-icon-theme"
    "breeze"
    "flatpak"
    "swaync"
    "gvfs"
    "wlogout"
    "hyprshade"
    "waypaper"
    "grimblast-git"
    "bibata-cursor-theme-bin"
    "pacseek"
    "otf-font-awesome"
    "ttf-fira-sans"
    "ttf-fira-code"
    "ttf-firacode-nerd"
    "ttf-dejavu"
    "nwg-dock-hyprland"
    "checkupdates-with-aur"
    "loupe"
    "power-profiles-daemon"
    "python-pywalfox"
    "vlc"
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
    _installPackages "base-devel"
    _installPackages "git"
    if [ -d $HOME/Downloads/yay ]; then
        rm -rf $HOME/Downloads/yay
    fi
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay.git $HOME/Downloads/yay
    cd $HOME/Downloads/yay
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

# Header
echo -e "${GREEN}"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/

EOF
echo "ML4W Dotfiles for Hyprland"
echo -e "${NONE}"
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]*)
            echo ":: Installation started."
            echo
            break
            ;;
        [Nn]*)
            echo ":: Installation canceled"
            exit
            break
            ;;
        *)
            echo ":: Please answer yes or no."
            ;;
    esac
done

# Install yay if needed
if [[ $(_checkCommandExists "yay") == 0 ]]; then
    echo ":: yay is already installed"
else
    echo ":: The installer requires yay. yay will be installed now"
    _installYay
fi

# Packages
_installPackages "${packages[@]}"

# Oh My Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Cargo
echo ":: Installing packages with cargo (this can take a while...)"
cargo install matugen
cargo install wallust

# ML4W Apps
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

# Flatpaks
flatpak install -y flathub com.github.PintaProject.Pinta

# Fonts
sudo cp -rf $SCRIPT_DIR/fonts/FiraCode /usr/share/fonts
sudo cp -rf $SCRIPT_DIR/fonts/Fira_Sans /usr/share/fonts

echo ":: Installation complete."
echo ":: Ready to install the dotfiles with the Dotfiles Installer."