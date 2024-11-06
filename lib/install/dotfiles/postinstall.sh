# ------------------------------------------------------
# Post Installation script
# ------------------------------------------------------
_writeLogHeader "Post install"

if [ -f ~/.config/ml4w/settings/dotfiles-folder.sh ] || [ -d ~/dotfiles ] ;then
    echo ":: Existing Dotfiles Installation detected. Post installation not needed."
else
    touch ~/.cache/ml4w-post-install
    echo ":: Post installation script created"
fi