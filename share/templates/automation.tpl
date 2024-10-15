#!/bin/bash
# Find the latest automation parameters here:
# https://github.com/mylinuxforwork/dotfiles/wiki/Automation-of-the-installation-and-update

# -----------------------------------------------------
# SYSTEM UPDATES
# true: Execute full system update with yay
# false: Skip system update with yay
# -----------------------------------------------------
automation_checkforupdates=false

# -----------------------------------------------------
# PARALLEL DOWNLOADS
# true: Will activate parallel downloads
# false: Skip the activation of parallel downloads
# -----------------------------------------------------
automation_paralleldownloads=true

# -----------------------------------------------------
# DOTFILES INSTALLATION FOLDER
# Define a folder including subfolder for the dotfiles
# E.g., dotfiles for installing in ~/dotfiles
# -----------------------------------------------------
automation_dotfilesfolder="dotfiles"

# -----------------------------------------------------
# OPTIONAL PACKAGES
# true: Offer the installation of optional packages
# false: Skip the installation of optional packages
# -----------------------------------------------------
automation_optional=false

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
# VM SUPPORT
# true: VM Support will be installed
# -----------------------------------------------------
automation_vm=false

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
# KEYBOARD
# true: Proceed with existing keyboard configuration
# -----------------------------------------------------
automation_keyboard=true

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
automation_kitty=true

# -----------------------------------------------------
# NEOVIM
# true: Install neovim configuration
# false: Skip installation of neovim configuration
# -----------------------------------------------------
automation_neovim=true

# -----------------------------------------------------
# COPY TO TARGETFOLDER
# true: Prepared dotfiles will be copied to the target folder
# -----------------------------------------------------
automation_copy=true

# -----------------------------------------------------
# RUN DIAGNOSIS
# true: Will execute the diagnosis script
# -----------------------------------------------------
automation_diagnosis=true

# -----------------------------------------------------
# EXECUTE POST SCRIPT
# true: Execute the post.sh if exists
# -----------------------------------------------------
automation_post=false