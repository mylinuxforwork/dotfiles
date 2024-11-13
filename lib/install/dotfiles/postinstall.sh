# ------------------------------------------------------
# Post Installation script
# ------------------------------------------------------
_writeLogHeader "Post install"

if [ -f ~/.config/ml4w/settings/dotfiles-folder.sh ] || [ -d ~/dotfiles ] ;then
    _writeLog 0 "Existing Dotfiles Installation detected. Post installation not needed."
else
    touch ~/.cache/ml4w-post-install
    _writeLog 0 "Post installation script created"
fi