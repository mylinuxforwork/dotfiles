#!/usr/bin/env bash

# Add copr repositories
sudo dnf copr remove --assumeyes solopasha/hyprland
sudo dnf copr enable --assumeyes sdegler/hyprland
sudo dnf copr enable --assumeyes peterwu/rendezvous
sudo dnf copr enable --assumeyes wef/cliphist
sudo dnf copr enable --assumeyes tofik/nwg-shell
sudo dnf copr enable --assumeyes che/nerd-fonts
sudo dnf copr enable --assumeyes erikreider/SwayNotificationCenter
sudo dnf copr enable --assumeyes errornointernet/quickshell
sudo dnf copr enable --assumeyes mineiro/hyprland 

# --------------------------------------------------------------
# Uninstall swww if exists. To be replaced with awww in the next steps
# --------------------------------------------------------------

if command -v swww &> /dev/null || dnf list installed swww &> /dev/null; then
    sudo dnf remove -y swww
fi