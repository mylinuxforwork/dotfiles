#!/bin/bash
# ------------------------------------------------------
# Don't edit this section
# Include scripts.sh with helper functions
source library/scripts.sh
# ------------------------------------------------------

# Show Current version
echo ":: Running hook for ML4W Dotfiles $version"

# If you made customizations on files on the ~/dotfiles folder 
# you can protect selected folders or files from the update.

_protect nvim
_protect .bashrc

# You can add more command to get executed before the prepared Dotfiles 
# will be copied to the target folder ~/dotfiles