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
    "hyprland-devel"
    "hyprland-qtutils"
    "hyprpaper"
    "hyprlock"
    "hypridle"
    "hyprpicker"
    "xdg-desktop-portal-hyprland"
    "libnotify-tools"
    "kitty"
    "libqt5-qtwayland"
    "qt6-wayland"
    "fastfetch"
    "xdg-desktop-portal-gtk"
    "eza"
    "python313-pipx"
    "tumbler"
    "brightnessctl"
    "ImageMagick"
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
    "NetworkManager-connection-editor"
    "fontawesome-fonts"
    "rofi-wayland"
    "zsh"
    "fzf"
    "pavucontrol"
    "papirus-icon-theme"
    "google-noto-fonts"
    "google-noto-emoji-fonts"
    "fontawesome-fonts"
    "dejavu-fonts"
    "breeze"
    "flatpak"
    "SwayNotificationCenter"
    "gvfs"
    "wlogout"
    "mozilla-fira-sans-fonts"
    "fira-code-fonts"
    "NetworkManager-tui"
    "nwg-dock-hyprland"
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

# Packages
_installPackages "${packages[@]}"

# Snap
sudo zypper addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
sudo zypper --gpg-auto-import-keys refresh
sudo zypper dup --from snappy
sudo zypper install snapd
sudo systemctl enable snapd
sudo systemctl start snapd
sudo systemctl enable snapd.apparmor
sudo systemctl start snapd.apparmor

# Gum
echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
sudo yum install --assumeyes gum

# Oh My Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Cargo
echo ":: Installing packages with cargo (this can take a while...)"
cargo install matugen
cargo install wallust
cargo install eza

# Install waypaper dependencies before using pip
sudo zypper install gcc pkg-config cairo-devel gobject-introspection-devel libgirepository-1_0-1-devel python3-devel libgtk-4-devel typelib-1_0-Gtk-4_0

# Pip
echo ":: Installing packages with pip"
sudo pipx install hyprshade
sudo pipx install pywalfox
sudo pywalfox install
sudo pipx install screeninfo
sudo pipx install waypaper

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

# Bibata Cursor Theme
sudo snap install cursor-theme-bibata

# Fonts
sudo cp -rf $SCRIPT_DIR/fonts/FiraCode /usr/share/fonts
sudo cp -rf $SCRIPT_DIR/fonts/Fira_Sans /usr/share/fonts

echo ":: Installation complete."
echo ":: Ready to install the dotfiles with the Dotfiles Installer."