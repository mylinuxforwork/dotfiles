#!/usr/bin/env bash

# --------------------------------------------------------------
# Uninstall swww if exists. To be replaced with awww in the next steps
# --------------------------------------------------------------

if command -v swww &> /dev/null; then
    sudo pacman -Rns --noconfirm swww
fi