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
lib_directory="$install_directory/install"

# ----------------------------------------------------- 
# Functions
# -----------------------------------------------------
source $lib_directory/includes/colors.sh
source $lib_directory/includes/library.sh

# ----------------------------------------------------- 
# Functions
# -----------------------------------------------------

clear

# ----------------------------------------------------- 
# Before start
# ----------------------------------------------------- 
source $lib_directory/before_start.sh

# ----------------------------------------------------- 
# Load header
# ----------------------------------------------------- 
source $lib_directory/header.sh

# ----------------------------------------------------- 
# Load automation variables
# ----------------------------------------------------- 
source $lib_directory/automation.sh

# ----------------------------------------------------- 
# Check for required packages
# ----------------------------------------------------- 
source $lib_directory/required.sh

# ----------------------------------------------------- 
# Confirm the start of the installation
# ----------------------------------------------------- 
source $lib_directory/confirm_start.sh

# ----------------------------------------------------- 
# Activate parallel downloads
# ----------------------------------------------------- 
source $lib_directory/paralleldownloads.sh

# ----------------------------------------------------- 
# Install yay
# ----------------------------------------------------- 
source $lib_directory/yay.sh

# ----------------------------------------------------- 
# Update the system
# -----------------------------------------------------
source $lib_directory/updatesystem.sh

clear

# ----------------------------------------------------- 
# Install profile
# ----------------------------------------------------- 
source $lib_directory/profile.sh

# ----------------------------------------------------- 
# Remove not required packages
# ----------------------------------------------------- 
source $lib_directory/remove.sh

# ----------------------------------------------------- 
# Install general packages
# ----------------------------------------------------- 
source $lib_directory/general.sh

# ----------------------------------------------------- 
# Check executables of important apps
# ----------------------------------------------------- 
source $lib_directory/diagnosis.sh
