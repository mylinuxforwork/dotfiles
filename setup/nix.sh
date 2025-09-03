#!/bin/bash

# /etc/nixos/configuration.nix
# Add git and flatpak

# Enable the Flakes feature and the accompanying new nix command-line tool
# nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Rebuild system
# sudo nixos-rebuild switch

# Install packages with flake
# nix profile install /path/to/your/flake/directory
