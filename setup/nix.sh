#!/bin/bash

# Enable Flakes: First, ensure you have flakes enabled in your Nix configuration. Add experimental-features = nix-command flakes to your /etc/nix/nix.conf or ~/.config/nix/nix.conf.
# Create Files: Place both flake.nix and home.nix in a new directory, e.g., ~/dotfiles.
# Replace Username: In flake.nix, change "your-username" to your actual username.
# Install Dependencies: Run the following command from the same directory where you created the files:
# nix develop --command sh -c "nix-shell --command 'home-manager switch --flake .'"
# home-manager switch --flake .#your-username

# /etc/nixos/configuration.nix
# Enable the Flakes feature and the accompanying new nix command-line tool
nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Install flake
nix run home-manager switch --flake .#raabe

# https://nixos-and-flakes.thiscute.world/