#!/bin/bash

# ----------------------------------------------------- 
# Load automation variables
# ----------------------------------------------------- 
source $install_directory/packages/automation.sh

# ----------------------------------------------------- 
# Dotfiles target folder
# ----------------------------------------------------- 
source $install_directory/dotfiles/dotfiles.sh

# ----------------------------------------------------- 
# AUR Helper
# ----------------------------------------------------- 
if [ -z $aur_helper ] ;then
    source $install_directory/packages/aur.sh
fi

# ----------------------------------------------------- 
# Post Installation
# ----------------------------------------------------- 
source $install_directory/dotfiles/postinstall.sh

# ----------------------------------------------------- 
# Backup files
# ----------------------------------------------------- 
source $install_directory/dotfiles/backup.sh

# ----------------------------------------------------- 
# Prepare files for the installation
# ----------------------------------------------------- 
source $install_directory/dotfiles/preparation.sh

# ----------------------------------------------------- 
# Check if running in Qemu VM
# ----------------------------------------------------- 
source $install_directory/dotfiles/vm.sh

# ----------------------------------------------------- 
# Install Display Manager
# -----------------------------------------------------
source $install_directory/dotfiles/displaymanager.sh

# ----------------------------------------------------- 
# Modify existing files before restore starts
# ----------------------------------------------------- 
source $install_directory/dotfiles/before_restore.sh

# ----------------------------------------------------- 
# Restore configuration and settings
# ----------------------------------------------------- 
source $install_directory/dotfiles/restore.sh

# ----------------------------------------------------- 
# Setup the input devices
# ----------------------------------------------------- 
source $install_directory/dotfiles/keyboard.sh

# ----------------------------------------------------- 
# Execute hook.sh if exists
# ----------------------------------------------------- 
source $install_directory/dotfiles/hook.sh

# ----------------------------------------------------- 
# Check installation of .bashrc
# ----------------------------------------------------- 
source $install_directory/dotfiles/bashrc.sh

# ----------------------------------------------------- 
# Check installation of .zshrc
# ----------------------------------------------------- 
source $install_directory/dotfiles/zshrc.sh

# ----------------------------------------------------- 
# Check installation of kitty
# ----------------------------------------------------- 
source $install_directory/dotfiles/kitty.sh

# ----------------------------------------------------- 
# Check installation of neovim
# ----------------------------------------------------- 
source $install_directory/dotfiles/neovim.sh

# ----------------------------------------------------- 
# Install wallpapers
# ----------------------------------------------------- 
source $install_directory/dotfiles/wallpaper.sh

# ----------------------------------------------------- 
# Check for protected folders
# ----------------------------------------------------- 
source $install_directory/dotfiles/protect.sh

# ----------------------------------------------------- 
# Copy files to target directory
# ----------------------------------------------------- 
source $install_directory/dotfiles/copy.sh

# ----------------------------------------------------- 
# Install profile symlinks
# ----------------------------------------------------- 
source $install_directory/dotfiles/symlinks.sh

# ----------------------------------------------------- 
# Initialize pywal color scheme
# ----------------------------------------------------- 
source $install_directory/dotfiles/pywal.sh

# ----------------------------------------------------- 
# Restore hyprland settings
# ----------------------------------------------------- 
source $install_directory/dotfiles/settings.sh

# ----------------------------------------------------- 
# Install ML4W Apps
# ----------------------------------------------------- 
source $install_directory/dotfiles/apps.sh

# ----------------------------------------------------- 
# Final cleanup
# ----------------------------------------------------- 
source $install_directory/dotfiles/cleanup.sh

# ----------------------------------------------------- 
# Execute post.sh
# ----------------------------------------------------- 
source $install_directory/dotfiles/post.sh

# ----------------------------------------------------- 
# Offer Reboot
# ----------------------------------------------------- 
source $install_directory/dotfiles/reboot.sh

