#!/bin/bash
# Find the latest automation parameters here:
# https://github.com/mylinuxforwork/dotfiles/wiki/Automation-of-the-installation-and-update

# -----------------------------------------------------
# AUR HELPER
# Define the aur helper when using Arch
# -----------------------------------------------------
# automation_aur="yay"

# -----------------------------------------------------
# DOTFILES INSTALLATION FOLDER
# Define a folder including subfolder for the dotfiles
# E.g., dotfiles for installing in ~/dotfiles
# -----------------------------------------------------
automation_dotfilesfolder="dotfiles"

# -----------------------------------------------------
# BACKUP OF YOUR DOTFILES
# true: Create a backup and archive it
# false: Skip the backup
# -----------------------------------------------------
automation_backup=true

# -----------------------------------------------------
# INSTALLTION
# true: Start the installation of new packages
# -----------------------------------------------------
automation_installation=true

# -----------------------------------------------------
# DISPLAY MANAGER
# true: Keep current setup
# -----------------------------------------------------
automation_displaymanager=true

# -----------------------------------------------------
# RESTORE
# true: Try to restore existing settings and configurations
# -----------------------------------------------------
automation_restore=true

# -----------------------------------------------------
# EXECUTE HOOK SCRIPT
# true: Execute the hook.sh if exists
# -----------------------------------------------------
automation_hook=false

# -----------------------------------------------------
# BASH RC
# true: Install the ML4W .bashrc
# false: Keep existing .bashrc
# -----------------------------------------------------
automation_bashrc=true

# -----------------------------------------------------
# ZSH RC
# true: Install the ML4W .zshrc
# false: Keep existing .zshrc
# -----------------------------------------------------
automation_zshrc=true

# -----------------------------------------------------
# KITTY
# true: Install kitty configuration
# false: Skip installation of kitty configuration
# -----------------------------------------------------
automation_kitty=false

# -----------------------------------------------------
# NEOVIM
# true: Install neovim configuration
# false: Skip installation of neovim configuration
# -----------------------------------------------------
automation_neovim=false

# -----------------------------------------------------
# COPY TO TARGETFOLDER
# true: Prepared dotfiles will be copied to the target folder
# -----------------------------------------------------
automation_copy=true

# -----------------------------------------------------
# EXECUTE POST SCRIPT
# true: Execute the post.sh if exists
# -----------------------------------------------------
automation_post=false