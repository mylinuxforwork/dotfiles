# ----------------------------------------------------- 
# Select Platform
# ----------------------------------------------------- 
source $install_directory/packages/platform.sh

# ----------------------------------------------------- 
# Before start
# ----------------------------------------------------- 
source $install_directory/packages/required.sh

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
# Cleanbuild
# ----------------------------------------------------- 
# source $install_directory/packages/cleanbuild.sh

# ----------------------------------------------------- 
# Check executables of important apps
# ----------------------------------------------------- 
source $install_directory/packages/diagnosis.sh
