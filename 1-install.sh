#!/bin/bash

# ------------------------------------------------------
# Install Script for dotfiles and configuration
# yay must be installed
# ------------------------------------------------------

read -p "Do you want to start? yay must be installed! " s
echo "START INSTALLATION..."

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo "-> Install main packages"
sudo pacman -S alacritty scrot nitrogen picom starship chromium slock neomutt rofi dunst ueberzug mpv freerdp spotifyd xfce4-power-manager python-pip thunar mousepad lxappearance papirus-icon-theme ttf-font-awesome ttf-fira-sans ttf-fira-code ttf-firacode-nerd figlet cmatrix qalculate-gtk adapta-gtk-theme terminator

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo "-> Install AUR packages"
yay -S pywal timeshift tela-circle-icon-theme-orange

# ------------------------------------------------------
# Install Pip packages
# ------------------------------------------------------
echo "-> Install Pip packages"
pip install psutil

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo "-> Create symbolic links"
mkdir ~/.config
ln -s ~/dotfiles/qtile/ ~/.config
ln -s ~/dotfiles/alacritty/ ~/.config
ln -s ~/dotfiles/neomutt/ ~/.config
ln -s ~/dotfiles/picom/ ~/.config
ln -s ~/dotfiles/ranger/ ~/.config
ln -s ~/dotfiles/rofi/ ~/.config
ln -s ~/dotfiles/spotifyd/ ~/.config
ln -s ~/dotfiles/vim/ ~/.config
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship.toml
rm ~/.bashrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
rm ~/.gtkrc-2.0
ln -s ~/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0
rm -r ~/.config/gtk-3.0/
ln -s ~/dotfiles/gtk-3.0/ ~/.config/

# ------------------------------------------------------
# Clone wallpapers
# ------------------------------------------------------
echo "-> Install wallpapers"
git clone https://gitlab.com/stephan-raabe/wallpaper.git ~/wallpaper

# ------------------------------------------------------
# Install startship plain text 
# ------------------------------------------------------
# starship preset plain-text-symbols > ~/.config/starship.toml

# ------------------------------------------------------
# Init pywal
# ------------------------------------------------------
wal -i ~/wallpaper/default.jpg -n

echo "DONE!"
