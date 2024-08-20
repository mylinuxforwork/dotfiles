#!/bin/bash

# ----------------------------------------------------- 
# Before start
# ----------------------------------------------------- 
source $install_directory/packages/before_start.sh

# ----------------------------------------------------- 
# Load automation variables
# ----------------------------------------------------- 
source $install_directory/packages/automation.sh

# ----------------------------------------------------- 
# Check for required packages
# ----------------------------------------------------- 
source $install_directory/packages/required.sh

# ----------------------------------------------------- 
# Confirm the start of the installation
# ----------------------------------------------------- 
source $install_directory/packages/confirm_start.sh

# ----------------------------------------------------- 
# Activate parallel downloads
# ----------------------------------------------------- 
source $install_directory/packages/paralleldownloads.sh

# ----------------------------------------------------- 
# Install yay
# ----------------------------------------------------- 
source $install_directory/packages/yay.sh

# ----------------------------------------------------- 
# Update the system
# -----------------------------------------------------
source $install_directory/packages/updatesystem.sh

# ----------------------------------------------------- 
# Install profile
# ----------------------------------------------------- 
source $install_directory/packages/profile.sh

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
