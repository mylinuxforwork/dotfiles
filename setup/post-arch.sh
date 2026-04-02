#!/usr/bin/env bash

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# ML4W Settings App
# --------------------------------------------------------------

bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/ml4w-dotfiles-settings/main/setup.sh)
rm $HOME/.local/share/ml4w-dotfiles-settings/quickshell/shared/Theme.qml  
ln -sf $HOME/.config/quickshell/shared/Theme.qml $HOME/.local/share/ml4w-dotfiles-settings/quickshell/shared/Theme.qml

# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

source $repo_path/setup/_cursors.sh

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

source $repo_path/setup/_fonts.sh

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

source $repo_path/setup/_icons.sh

# --------------------------------------------------------------
# Create XDG Directories
# --------------------------------------------------------------

xdg-user-dirs-update

