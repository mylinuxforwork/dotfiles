#!/bin/bash

# ----------------------------------------------------- 
# Before start
# ----------------------------------------------------- 
source $lib_directory/packages/before_start.sh

# ----------------------------------------------------- 
# Load automation variables
# ----------------------------------------------------- 
source $lib_directory/packages/automation.sh

# ----------------------------------------------------- 
# Check for required packages
# ----------------------------------------------------- 
source $lib_directory/packages/required.sh

# ----------------------------------------------------- 
# Confirm the start of the installation
# ----------------------------------------------------- 
source $lib_directory/packages/confirm_start.sh

# ----------------------------------------------------- 
# Activate parallel downloads
# ----------------------------------------------------- 
source $lib_directory/packages/paralleldownloads.sh

# ----------------------------------------------------- 
# Install yay
# ----------------------------------------------------- 
source $lib_directory/packages/yay.sh

# ----------------------------------------------------- 
# Update the system
# -----------------------------------------------------
source $lib_directory/packages/updatesystem.sh

# ----------------------------------------------------- 
# Install profile
# ----------------------------------------------------- 
source $lib_directory/packages/profile.sh

# ----------------------------------------------------- 
# Remove not required packages
# ----------------------------------------------------- 
source $lib_directory/packages/remove.sh

# ----------------------------------------------------- 
# Install packages
# ----------------------------------------------------- 
source $lib_directory/packages/packages.sh

# ----------------------------------------------------- 
# Check executables of important apps
# ----------------------------------------------------- 
source $lib_directory/packages/diagnosis.sh
