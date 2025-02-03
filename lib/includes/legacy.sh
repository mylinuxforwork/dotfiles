# Check for legacy folders
if [ -d ~/dotfiles-versions ]; then
    mv ~/dotfiles-versions $ml4w_directory
fi
if [ -d ~/.ml4w-dotfiles ]; then
    mv ~/.ml4w-dotfiles $ml4w_directory
fi
