#!/bin/bash

# ----------------------------------------------------- 
# Before start
# ----------------------------------------------------- 
source $install_directory/packages/before_start.sh

# ----------------------------------------------------- 
# Confirm start
# ----------------------------------------------------- 
source $install_directory/packages/confirm_start.sh

# ----------------------------------------------------- 
# Load automation variables
# ----------------------------------------------------- 
source $install_directory/packages/automation.sh

# ----------------------------------------------------- 
# Install AUR Helper
# ----------------------------------------------------- 
source $install_directory/packages/aur.sh

# ----------------------------------------------------- 
# Remove not required packages
# ----------------------------------------------------- 
source $install_directory/packages/remove.sh

# ----------------------------------------------------- 
# Install packages
# ----------------------------------------------------- 
source $install_directory/packages/packages.sh

# ----------------------------------------------------- 
# Check executables of important apps
# ----------------------------------------------------- 
source $install_directory/packages/diagnosis.sh
