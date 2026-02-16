#!/usr/bin/env bash

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# Prebuild Packages
# --------------------------------------------------------------

source $SCRIPT_DIR/_prebuilt.sh

echo "Installing eza v0.23.0"
# https://github.com/eza-community/eza/releases
sudo cp $SCRIPT_DIR/packages/eza /usr/bin

# --------------------------------------------------------------
# Pip
# --------------------------------------------------------------

echo ":: Installing packages with pip"
sudo pip install hyprshade
sudo pip install pywalfox
sudo pip install screeninfo
sudo pip install waypaper

# --------------------------------------------------------------
# TTY Clock
# --------------------------------------------------------------

# git clone https://github.com/xorg62/tty-clock
# cd tty-clock
# sudo dnf install ncurses ncurses-devel -y
# make
# chmod +x tty-clock
# sudo mv tty-clock /usr/local/bin/tty-clock

# --------------------------------------------------------------
# ML4W Apps
# --------------------------------------------------------------

source $SCRIPT_DIR/_ml4w-apps.sh

# --------------------------------------------------------------
# Flatpaks
# --------------------------------------------------------------

source $SCRIPT_DIR/_flatpaks.sh

# --------------------------------------------------------------
# Grimblast
# --------------------------------------------------------------

sudo cp $SCRIPT_DIR/scripts/grimblast /usr/bin

# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

source $SCRIPT_DIR/_cursors.sh

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

source $SCRIPT_DIR/_fonts.sh

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

source $SCRIPT_DIR/_icons.sh

# --------------------------------------------------------------
# Create XDG Directories
# --------------------------------------------------------------

xdg-user-dirs-update
