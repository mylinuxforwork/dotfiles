#!/usr/bin/env bash

packages=(
    "wget"
    "unzip"
    "gum"
    "rsync"
    "git"
    "figlet"
    "xdg-user-dirs"
    # Hyprland
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
    "python-3pip"
    "python-gobject"
    "tumbler"
    "brightnessctl"
    "nm-connection-editor"
    "network-manager-applet"
    "gtk4"
    "libadwaita"
    "fuse2"
    "imageMagick"
    "jq"
    "xclip"
    "kitty"
    "neovim"
    "htop"
    "rust"
    "cargo"
    "pinta"
    "blueman"
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
    "hyprshade"
    "pinta"
    "bibata-cursor-themes"
    "fontawesome-6-free-fonts"
    "mozilla-fira-sans-fonts"
    "fira-code-fonts"
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
    check=$(yum list installed | grep $package)
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
    sudo dnf install --assumeyes "${toInstall[@]}"
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
sudo dnf copr enable --assumeyes "tofik/nwg-shell"
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
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Cargo
cargo install -q matugen
cargo install -q wallust
cargo install -q eza

# Pip
sudo pip install hyprshade
sudo pip install pywalfox
sudo pywalfox install
sudo pip install screeninfo
sudo pip install waypaper

echo ":: Installation complete."
echo ":: Ready to install the dotfiles with the Dotfiles Installer."