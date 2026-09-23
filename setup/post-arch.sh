#!/usr/bin/env bash

# --------------------------------------------------------------
# Pipx
# --------------------------------------------------------------

echo ":: Installing packages with pipx"
pipx install pywalfox
pywalfox-install

# --------------------------------------------------------------
# Grimblast
# --------------------------------------------------------------

pacman -Qi grimblast-git &>/dev/null || source $repo_path/setup/clean-install-grimblast.sh


