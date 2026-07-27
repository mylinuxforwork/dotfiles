#!/usr/bin/env bash
# Add copr repositories

# Hyprland Packages
sudo dnf copr enable --assumeyes lionheartp/Hyprland
# sudo dnf copr enable --assumeyes mineiro/hyprland
# sudo dnf copr enable --assumeyes sdegler/hyprland

# Bibata Cursor Themes
sudo dnf copr enable --assumeyes peterwu/rendezvous

# Cliphist
# sudo dnf copr enable --assumeyes wef/cliphist

# nwg displays and nwg-look
sudo dnf copr enable --assumeyes tofik/nwg-shell

# Nerd Fonts
sudo dnf copr enable --assumeyes che/nerd-fonts

# SwayNC
sudo dnf copr enable --assumeyes erikreider/SwayNotificationCenter

# Quickshell
# sudo dnf copr enable --assumeyes errornointernet/quickshell

# --------------------------------------------------------------
# Uninstall swww if exists. To be replaced with awww in the next steps
# --------------------------------------------------------------

if command -v swww &> /dev/null || dnf list installed swww &> /dev/null; then
    sudo dnf remove -y swww
fi