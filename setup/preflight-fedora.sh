#!/usr/bin/env bash

# Add copr repositories
sudo dnf copr remove --assumeyes solopasha/hyprland
sudo dnf copr enable --assumeyes sdegler/hyprland
sudo dnf copr enable --assumeyes peterwu/rendezvous
sudo dnf copr enable --assumeyes wef/cliphist
sudo dnf copr enable --assumeyes tofik/nwg-shell
sudo dnf copr enable --assumeyes che/nerd-fonts
sudo dnf copr enable --assumeyes erikreider/SwayNotificationCenter