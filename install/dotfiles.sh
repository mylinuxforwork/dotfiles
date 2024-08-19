#!/bin/bash

# ----------------------------------------------------- 
# Load automation variables
# ----------------------------------------------------- 
source $lib_directory/packages/automation.sh

# ----------------------------------------------------- 
# Dotfiles target folder
# ----------------------------------------------------- 
source $lib_directory/dotfiles/dotfiles.sh

# ----------------------------------------------------- 
# Post Installation
# ----------------------------------------------------- 
source $lib_directory/dotfiles/postinstall.sh

# ----------------------------------------------------- 
# Backup files
# ----------------------------------------------------- 
source $lib_directory/dotfiles/backup.sh

# ----------------------------------------------------- 
# Prepare files for the installation
# ----------------------------------------------------- 
source $lib_directory/dotfiles/preparation.sh

# ----------------------------------------------------- 
# Check if running in Qemu VM
# ----------------------------------------------------- 
source $lib_directory/dotfiles/vm.sh

# ----------------------------------------------------- 
# Install Display Manager
# -----------------------------------------------------
source $lib_directory/dotfiles/displaymanager.sh

# ----------------------------------------------------- 
# Modify existing files before restore starts
# ----------------------------------------------------- 
source $lib_directory/dotfiles/before_restore.sh

# ----------------------------------------------------- 
# Restore configuration and settings
# ----------------------------------------------------- 
source $lib_directory/dotfiles/restore.sh

# ----------------------------------------------------- 
# Setup the input devices
# ----------------------------------------------------- 
source $lib_directory/dotfiles/keyboard.sh

# ----------------------------------------------------- 
# Execute hook.sh if exists
# ----------------------------------------------------- 
source $lib_directory/dotfiles/hook.sh

# ----------------------------------------------------- 
# Check installation of .bashrc
# ----------------------------------------------------- 
source $lib_directory/dotfiles/bashrc.sh

# ----------------------------------------------------- 
# Check installation of .zshrc
# ----------------------------------------------------- 
source $lib_directory/dotfiles/zshrc.sh

# ----------------------------------------------------- 
# Check installation of neovim
# ----------------------------------------------------- 
source $lib_directory/dotfiles/neovim.sh

# ----------------------------------------------------- 
# Copy files to target directory
# ----------------------------------------------------- 
source $lib_directory/dotfiles/copy.sh

# ----------------------------------------------------- 
# Install profile symlinks
# ----------------------------------------------------- 
source $lib_directory/dotfiles/symlinks.sh

# ----------------------------------------------------- 
# Install wallpapers
# ----------------------------------------------------- 
source $lib_directory/dotfiles/wallpaper.sh

# ----------------------------------------------------- 
# Initialize pywal color scheme
# ----------------------------------------------------- 
source $lib_directory/dotfiles/init-pywal.sh

# ----------------------------------------------------- 
# Restore hyprland settings
# ----------------------------------------------------- 
source $lib_directory/dotfiles/settings.sh

# ----------------------------------------------------- 
# Install ML4W Apps
# ----------------------------------------------------- 
source $lib_directory/dotfiles/apps.sh

# ----------------------------------------------------- 
# Final cleanup
# ----------------------------------------------------- 
source $lib_directory/dotfiles/cleanup.sh

# ----------------------------------------------------- 
# Execute post.sh if exists
# ----------------------------------------------------- 
source $lib_directory/dotfiles/post.sh

# ----------------------------------------------------- 
# Offer Reboot
# ----------------------------------------------------- 
source $lib_directory/dotfiles/reboot.sh

