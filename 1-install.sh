#!/bin/bash
#      _       _    __ _ _           
#   __| | ___ | |_ / _(_) | ___  ___ 
#  / _` |/ _ \| __| |_| | |/ _ \/ __|
# | (_| | (_) | |_|  _| | |  __/\__ \
#  \__,_|\___/ \__|_| |_|_|\___||___/
#                                    
# by Stephan Raabe (2023)
# ------------------------------------------------------
# Install Script for dotfiles and configuration
# yay must be installed
# ------------------------------------------------------

# ------------------------------------------------------
# Load Library
# ------------------------------------------------------
source $(dirname "$0")/scripts/library.sh
clear
echo "     _       _    __ _ _            "
echo "  __| | ___ | |_ / _(_) | ___  ___  "
echo " / _' |/ _ \| __| |_| | |/ _ \/ __| "
echo "| (_| | (_) | |_|  _| | |  __/\__ \ "
echo " \__,_|\___/ \__|_| |_|_|\___||___/ "
echo "                                    "
echo "by Stephan Raabe (2023)"
echo "-------------------------------------"
echo ""
echo "The script will not remove any folders or files."
echo "Symbolic links will be created instead when the folder or files doesn't exists."
echo "If you want to overwrite your configuration please remove the correspondig folder in your .config first."
echo "(For example ~/.config/qtile, etc.)"
echo ""

# ------------------------------------------------------
# Check if yay is installed
# ------------------------------------------------------
if sudo pacman -Qs yay > /dev/null ; then
    echo "yay is installed. You can proceed with the installation"
else
    echo "yay is not installed. Will be installed now!"
    git clone https://aur.archlinux.org/yay-git.git ~/yay-git
    cd ~/yay-git
    makepkg -si
    cd ~/dotfiles/
fi

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo ""
echo "-> Install main packages"

packagesPacman=("picom" "alacritty" "rofi" "rofi-calc" "chromium" "scrot" "nitrogen" "dunst" "starship" "slock" "neovim" "mpv" "freerdp" "xfce4-power-manager" "thunar" "mousepad" "ttf-font-awesome" "ttf-fira-sans" "ttf-fira-code" "ttf-firacode-nerd" "figlet" "lxappearance" "breeze" "breeze-gtk" "vlc" "exa" "python-pip" "python-psutil" "python-rich" "python-click" "xdg-desktop-portal-gtk" "pavucontrol" "tumbler" "xautolock" "blueman");

packagesYay=("brave-bin" "pfetch" "bibata-cursor-theme" "trizen");
  
# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
_installPackagesPacman "${packagesPacman[@]}";
_installPackagesYay "${packagesYay[@]}";

# ------------------------------------------------------
# Install pywal
# ------------------------------------------------------
if [ -f /usr/bin/wal ]; then
    echo "pywal already installed."
else
    yay --noconfirm -S pywal
fi

clear

# ------------------------------------------------------
# Create .config folder
# ------------------------------------------------------
echo ""
echo "-> Install .config folder"

if [ -d ~/.config ]; then
    echo ".config folder already exists."
else
    mkdir ~/.config
    echo ".config folder created."
fi

# ------------------------------------------------------
# Remove pywal folder from .config
# ------------------------------------------------------
echo ""
if [ -d ~/.config/wal/ ]; then
    rm -r ~/.config/wal/
    echo "~/.config/wal/ removed."
fi

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo ""
echo "-> Install symbolic links"

_installSymLink ~/.config/picom ~/dotfiles/picom/ ~/.config
_installSymLink ~/.config/alacritty ~/dotfiles/alacritty/ ~/.config
_installSymLink ~/.config/rofi ~/dotfiles/rofi/ ~/.config
_installSymLink ~/.config/vim ~/dotfiles/vim/ ~/.config
_installSymLink ~/.config/nvim ~/dotfiles/nvim/ ~/.config
_installSymLink ~/.config/dunst ~/dotfiles/dunst/ ~/.config
_installSymLink ~/.config/wal ~/dotfiles/wal/ ~/.config
_installSymLink ~/.config/starship.toml ~/dotfiles/starship/starship.toml ~/.config/starship.toml

# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------
echo ""
echo "-> Install .bashrc"
while true; do
    read -p "Do you want to replace the existing .bashrc file? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            rm ~/.bashrc
            echo ".bashrc removed"
        break;;
        [Nn]* ) 
            echo "Replacement of .bashrc skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
_installSymLink ~/.bashrc ~/dotfiles/.bashrc ~/.bashrc

# ------------------------------------------------------
# Install Theme, Icons and Cursor
# ------------------------------------------------------
echo ""
echo "-> Install Theme"
while true; do
    read -p "Do you want to replace the existing GTK2/GTK3 theme configuration? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            if [ -d ~/.config/gtk-3.0 ]; then
                rm -r ~/.config/gtk-3.0
                echo "gtk-3.0 removed"
            fi

            if [ -f ~/.gtkrc-2.0 ]; then
                rm ~/.gtkrc-2.0
                echo ".gtkrc-2.0"
            fi

            if [ -f ~/.Xresources ]; then
                rm ~/.Xresources
                echo ".Xresources removed"
            fi
            
            if [ -d ~/.icons ]; then
                rm -r ~/.icons
                echo ".icons removed"
            fi
            
            _installSymLink ~/.gtkrc-2.0 ~/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0
            _installSymLink ~/.config/gtk-3.0 ~/dotfiles/gtk-3.0/ ~/.config/
            _installSymLink ~/.Xresources ~/dotfiles/.Xresources ~/.Xresources
            _installSymLink ~/.icons ~/dotfiles/.icons/ ~/

            echo "Existing theme removed"
        break;;
        [Nn]* ) 
            echo "Replacement of theme skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Install custom issue (login prompt)
# ------------------------------------------------------
echo ""
echo "-> Install login screen"
while true; do
    read -p "Do you want to install the custom login promt? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            sudo cp ~/dotfiles/issue /etc/issue
            echo "Login promt installed."
        break;;
        [Nn]* ) 
            echo "Custom login promt skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------
echo ""
echo "-> Install wallapers"
while true; do
    read -p "Do you want to clone the wallpapers? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            if [ -d ~/wallpaper/ ]; then
                echo "wallpaper folder already exists."
            else
                git clone https://gitlab.com/stephan-raabe/wallpaper.git ~/wallpaper
                echo "wallpaper installed."
            fi
            echo "Wallpaper installed."
        break;;
        [Nn]* ) 
            if [ -d ~/wallpaper/ ]; then
                echo "wallpaper folder already exists."
            else
                mkdir ~/wallpaper
            fi
            cp ~/dotfiles/default.jpg ~/wallpaper
            echo "Default wallpaper installed."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Init pywal
# ------------------------------------------------------
echo ""
echo "-> Init pywal"
wal -i ~/dotfiles/default.jpg
echo "pywal initiated."

# ------------------------------------------------------
# DONE
# ------------------------------------------------------
clear
echo "DONE!"
