#!/bin/bash
# ------------------------------------------------------
# Don't edit this section
# Include scripts.sh with helper functions
source library/scripts.sh
# ------------------------------------------------------

# Show Current version
echo ":: Running hook for ML4W Dotfiles $version"

# If you made adjustments on files on the ~/dotfiles folder 
# you can protect the files and folders from being overwritten by updates.

_protect .config/nvim
_protect .bashrc

# You can add more command to get executed before the prepared Dotfiles 
# will be copied to the target folder ~/dotfiles