#!/bin/bash

# ----------------------------------------------------- 
# Variables
# -----------------------------------------------------
version=$(cat dotfiles/.config/ml4w/version/name)

# ----------------------------------------------------- 
# Folders
# -----------------------------------------------------
install_directory=$(pwd)
ml4w_directory=".ml4w-dotfiles"
backup_directory="$ml4w_directory/backup"
archive_directory="$ml4w_directory/archive"
lib_directory="$install_directory/install"

# ----------------------------------------------------- 
# Functions
# -----------------------------------------------------
source $lib_directory/includes/colors.sh
source $lib_directory/includes/library.sh

clear

# ----------------------------------------------------- 
# Load automation variables
# ----------------------------------------------------- 
source $lib_directory/automation.sh

# ----------------------------------------------------- 
# Before start
# ----------------------------------------------------- 
source $lib_directory/before_start.sh

# ----------------------------------------------------- 
# Post Installation
# ----------------------------------------------------- 
source $lib_directory/postinstall.sh

# ----------------------------------------------------- 
# Dotfiles target folder
# ----------------------------------------------------- 
source $lib_directory/dotfiles.sh

# ----------------------------------------------------- 
# Backup files
# ----------------------------------------------------- 
source $lib_directory/backup.sh

# ----------------------------------------------------- 
# Prepare files for the installation
# ----------------------------------------------------- 
source $lib_directory/preparation.sh

# ----------------------------------------------------- 
# Check if running in Qemu VM
# ----------------------------------------------------- 
source $lib_directory/vm.sh

# ----------------------------------------------------- 
# Install Display Manager
# -----------------------------------------------------
source $lib_directory/displaymanager.sh

# ----------------------------------------------------- 
# Modify existing files before restore starts
# ----------------------------------------------------- 
source $lib_directory/before_restore.sh

# ----------------------------------------------------- 
# Restore configuration and settings
# ----------------------------------------------------- 
source $lib_directory/restore.sh

# ----------------------------------------------------- 
# Setup the input devices
# ----------------------------------------------------- 
source $lib_directory/keyboard.sh

# ----------------------------------------------------- 
# Execute hook.sh if exists
# ----------------------------------------------------- 
source $lib_directory/hook.sh

# ----------------------------------------------------- 
# Check installation of .bashrc
# ----------------------------------------------------- 
source $lib_directory/bashrc.sh

# ----------------------------------------------------- 
# Check installation of .zshrc
# ----------------------------------------------------- 
source $lib_directory/zshrc.sh

# ----------------------------------------------------- 
# Check installation of neovim
# ----------------------------------------------------- 
source $lib_directory/neovim.sh

# ----------------------------------------------------- 
# Copy files to target directory
# ----------------------------------------------------- 
source $lib_directory/copy.sh

# ----------------------------------------------------- 
# Install profile symlinks
# ----------------------------------------------------- 
source $lib_directory/symlinks.sh

# ----------------------------------------------------- 
# Install wallpapers
# ----------------------------------------------------- 
source $lib_directory/wallpaper.sh

# ----------------------------------------------------- 
# Initialize pywal color scheme
# ----------------------------------------------------- 
source $lib_directory/init-pywal.sh

# ----------------------------------------------------- 
# Restore hyprland settings
# ----------------------------------------------------- 
source $lib_directory/settings.sh

# ----------------------------------------------------- 
# Install ML4W Apps
# ----------------------------------------------------- 
source $lib_directory/apps.sh

# ----------------------------------------------------- 
# Final cleanup
# ----------------------------------------------------- 
source $lib_directory/cleanup.sh

# ----------------------------------------------------- 
# Execute post.sh if exists
# ----------------------------------------------------- 
source $lib_directory/post.sh

# ----------------------------------------------------- 
# Offer Reboot
# ----------------------------------------------------- 
source $lib_directory/reboot.sh

