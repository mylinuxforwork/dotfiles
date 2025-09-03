#!/bin/bash

# /etc/nixos/configuration.nix
# Add git to system wide packages

# Enable Flatpak service
# services.flatpak.enable = true;

# Enable the Flakes feature and the accompanying new nix command-line tool
# nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Rebuild system
# sudo nixos-rebuild switch

# Add Flathub repository
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install packages with flake
# nix profile install /path/to/your/flake/directory

# sudo nixos-rebuild switch --impure --flake .
