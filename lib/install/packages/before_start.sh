# ------------------------------------------------------
# Before Start
# ------------------------------------------------------

if [ -d ~/dotfiles-versions ]; then
    mv ~/dotfiles-versions "$ml4w_directory"
    echo ":: PLEASE NOTE: ~/dotfiles-versions folder renamed to $ml4w_directory"
fi
if [ -d ~/.ml4w-dotfiles ]; then
    mv ~/.ml4w-dotfiles "$ml4w_directory"
    echo ":: PLEASE NOTE: ~/.ml4w-dotfiles folder renamed to $ml4w_directory"
fi
