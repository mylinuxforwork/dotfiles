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
    "google-noto-emoji-fonts"
    "google-noto-sans-cjk-fonts"
    "xdg-desktop-portal-hyprland"
    "libnotify"
    "kitty"
    "qt5-qtwayland"
    "qt6-qtwayland"
    "uwsm"
    "fastfetch"
    "xdg-desktop-portal-gtk"
    "python-pip"
    "python3-gobject"
    "tumbler"
    "brightnessctl"
    "nm-connection-editor"
    "network-manager-applet"
    "gtk4"
    "libadwaita"
    "fuse"
    "ImageMagick"
    "jq"
    "xclip"
    "kitty"
    "neovim"
    "htop"
    "rust"
    "cargo"
    "blueman"
    "waypaper"
    "grim"
    "slurp"
    "cliphist"
    "nwg-look"
    "qt6ct"
    "waybar"
    "rofi-wayland"
    "zsh"
    "fzf"
    "pavucontrol"
    "papirus-icon-theme"
    "papirus-icon-theme-dark"
    "breeze"
    "flatpak"
    "SwayNotificationCenter"
    "gvfs"
    "wlogout"
    "bibata-cursor-themes"
    "fontawesome-fonts"
    "dejavu-fonts-all"
    "flatpak"
    "NetworkManager-tui"
    "nwg-dock-hyprland"
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
    check=$(dnf list --installed | grep $package)
    if [ -z "$check" ]; then
        echo 1
        return #false
    else
        echo 0
        return #true
    fi
}

_installPackages() {
    toInstall=()
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed."
            continue
        fi
        toInstall+=("${pkg}")
    done
    if [[ "${toInstall[@]}" == "" ]]; then
        return
    fi
    printf "Package not installed:\n%s\n" "${toInstall[@]}"
    sudo dnf install --assumeyes --skip-unavailable "${toInstall[@]}"
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

sudo dnf copr enable --assumeyes solopasha/hyprland
sudo dnf copr enable --assumeyes peterwu/rendezvous
sudo dnf copr enable --assumeyes wef/cliphist
sudo dnf copr enable --assumeyes tofik/nwg-shell
sudo dnf copr enable --assumeyes erikreider/SwayNotificationCenter

# Packages
_installPackages "${packages[@]}"

# Gum
echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
sudo yum install --assumeyes gum

# Oh My Posh
sudo curl -s https://ohmyposh.dev/install.sh | bash -s

# Cargo
echo ":: Installing packages with cargo (this can take a while...)"
cargo install matugen
cargo install wallust
cargo install eza

# Pip
echo ":: Installing packages with pip"
sudo pip install hyprshade
sudo pip install pywalfox
sudo pywalfox install
sudo pip install screeninfo
sudo pip install waypaper

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

# Grimblast
sudo cp $SCRIPT_DIR/scripts/grimblast /usr/bin

# Fonts
sudo cp -rf $SCRIPT_DIR/fonts/FiraCode /usr/share/fonts
sudo cp -rf $SCRIPT_DIR/fonts/Fira_Sans /usr/share/fonts

echo ":: Installation complete."
echo ":: Ready to install the dotfiles with the Dotfiles Installer."