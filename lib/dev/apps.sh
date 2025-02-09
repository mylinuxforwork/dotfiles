#!/bin/bash
dotfiles="$HOME/.ml4w-hyprland/dotfiles"

# apps
$dotfiles/lib/install/dotfiles/flatpak.sh $dotfiles/share/apps dev

echo ":: Apps installed"
