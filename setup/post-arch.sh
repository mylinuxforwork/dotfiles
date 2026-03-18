#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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
# Prebuilt Packages
# --------------------------------------------------------------

source $SCRIPT_DIR/_prebuilt.sh

# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

source $SCRIPT_DIR/_cursors.sh

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

source $SCRIPT_DIR/_fonts.sh

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

source $SCRIPT_DIR/_icons.sh

# --------------------------------------------------------------
# Migrate
# --------------------------------------------------------------

source $SCRIPT_DIR/migrate.sh

# --------------------------------------------------------------
# Create XDG Directories
# --------------------------------------------------------------

xdg-user-dirs-update
