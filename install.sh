#!/bin/bash

# ----------------------------------------------------- 
# Include files and set variables
# -----------------------------------------------------
version=$(cat dotfiles/.config/ml4w/version/name)
install_directory=$(pwd)
source install/includes/colors.sh
source install/includes/library.sh

clear

# ----------------------------------------------------- 
# Load header
# ----------------------------------------------------- 
source install/header.sh

# ----------------------------------------------------- 
# Load automation variables
# ----------------------------------------------------- 
source install/automation.sh

# ----------------------------------------------------- 
# Check for required packages
# ----------------------------------------------------- 
source install/required.sh

# ----------------------------------------------------- 
# Confirm the start of the installation
# ----------------------------------------------------- 
source install/confirm_start.sh

# ----------------------------------------------------- 
# Activate parallel downloads
# ----------------------------------------------------- 
if [ -z $automation_paralleldownloads ] ;then
    source install/paralleldownloads.sh
else
    if [[ "$automation_paralleldownloads" = true ]] ;then
        source install/automation/paralleldownloads.sh
    fi
fi


# ----------------------------------------------------- 
# Install yay
# ----------------------------------------------------- 
source install/yay.sh

# ----------------------------------------------------- 
# Update the system
# -----------------------------------------------------
if [ -z $automation_checkforupdates ] ;then
    source install/updatesystem.sh
else
    source install/automation/updatesystem.sh
fi 

clear

# ----------------------------------------------------- 
# Install profile
# ----------------------------------------------------- 
if [ -z $automation_profile ] ;then
    source install/profile.sh
else
    source install/automation/profile.sh
fi

# ----------------------------------------------------- 
# Decide on installation method
# ----------------------------------------------------- 
if [ -z $automation_installation ] ;then
    source install/installer.sh
else
    if [[ "$automation_installation" = true ]] ;then
        source install/automation/installer.sh
    else
        source install/installer.sh
    fi
fi

# ----------------------------------------------------- 
# Remove not required packages
# ----------------------------------------------------- 
source install/remove.sh

# ----------------------------------------------------- 
# Install general packages
# ----------------------------------------------------- 
source install/general.sh

# ----------------------------------------------------- 
# Check executables of important apps
# ----------------------------------------------------- 
if [ -z $automation_diagnosis ] ;then
    source install/diagnosis.sh
else
    if [[ "$automation_diagnosis" = true ]] ;then
        source install/automation/diagnosis.sh
    fi
fi

# ----------------------------------------------------- 
# Post Installation
# ----------------------------------------------------- 
source install/postinstall.sh

clear

# ----------------------------------------------------- 
# Dotfiles target folder
# ----------------------------------------------------- 
if [ -z $automation_dotfilesfolder ] ;then
    source install/dotfiles.sh
else
    source install/automation/dotfiles.sh
fi
# ----------------------------------------------------- 
# Backup files
# ----------------------------------------------------- 
if [ -z $automation_backup ] ;then
    source install/backup.sh
else
    source install/automation/backup.sh
fi
# ----------------------------------------------------- 
# Prepare files for the installation
# ----------------------------------------------------- 
source install/preparation.sh

# ----------------------------------------------------- 
# Check if running in Qemu VM
# ----------------------------------------------------- 
if [ -z $automation_vm ] ;then
    source install/vm.sh
else
    source install/automation/vm.sh
fi

# ----------------------------------------------------- 
# Install Display Manager
# -----------------------------------------------------
if [ -z $automation_displaymanager ] ;then
    source install/displaymanager.sh
else
    if [[ "$automation_displaymanager" = true ]] ;then
        source install/automation/displaymanager.sh
    else
        source install/displaymanager.sh
    fi
fi

# ----------------------------------------------------- 
# Install tty issue
# ----------------------------------------------------- 
source install/issue.sh

# ----------------------------------------------------- 
# Modify existing files before restore starts
# ----------------------------------------------------- 
source install/before_restore.sh

# ----------------------------------------------------- 
# Restore configuration and settings
# ----------------------------------------------------- 
if [ -z $automation_vm ] ;then
    source install/restore.sh
else
    if [[ "$automation_restore" = true ]] ;then
        source install/automation/restore.sh
    else
        restored=0
    fi
fi

# ----------------------------------------------------- 
# Setup the input devices
# ----------------------------------------------------- 
if [ -z $automation_keyboard ] ;then
    source install/keyboard.sh
else
    if [[ "$automation_keyboard" = true ]] && [[ "$restored" = 1 ]] ;then
        source install/automation/keyboard.sh
    else
        source install/keyboard.sh        
    fi
fi

# ----------------------------------------------------- 
# Execute hook.sh if exists
# ----------------------------------------------------- 
if [ -z $automation_hook ] ;then
    source install/hook.sh
else
    source install/automation/hook.sh
fi

# ----------------------------------------------------- 
# Check installation of .bashrc
# ----------------------------------------------------- 
if [ -z $automation_bashrc ] ;then
    source install/bashrc.sh
else
    source install/automation/bashrc.sh
fi

# ----------------------------------------------------- 
# Check installation of .bashrc
# ----------------------------------------------------- 
if [ -z $automation_zshrc ] ;then
    source install/zshrc.sh
else
    source install/automation/zshrc.sh
fi

# ----------------------------------------------------- 
# Check installation of neovim
# ----------------------------------------------------- 
if [ -z $automation_bashrc ] ;then
    source install/neovim.sh
else
    source install/automation/neovim.sh
fi
# ----------------------------------------------------- 
# Copy files to target directory
# ----------------------------------------------------- 
if [ -z $automation_copy ] ;then
    source install/copy.sh
else 
    if [[ "$automation_copy" = true ]] ;then
        source install/automation/copy.sh    
    else
        source install/copy.sh    
    fi
fi

# ----------------------------------------------------- 
# Install profile symlinks
# ----------------------------------------------------- 
source install/symlinks.sh

# ----------------------------------------------------- 
# Install wallpapers
# ----------------------------------------------------- 
source install/wallpaper.sh

# ----------------------------------------------------- 
# Initialize pywal color scheme
# ----------------------------------------------------- 
source install/init-pywal.sh

# ----------------------------------------------------- 
# Restore hyprland settings
# ----------------------------------------------------- 
source install/settings.sh

# ----------------------------------------------------- 
# Install ML4W Apps
# ----------------------------------------------------- 
source install/apps.sh

# ----------------------------------------------------- 
# Final cleanup
# ----------------------------------------------------- 
source install/cleanup.sh

# ----------------------------------------------------- 
# Execute post.sh if exists
# ----------------------------------------------------- 
if [ -z $automation_post ] ;then
    source install/post.sh
else
    source install/automation/post.sh
fi

# ----------------------------------------------------- 
# Offer Reboot
# ----------------------------------------------------- 
source install/reboot.sh

