#!/bin/bash
clear
aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"
figlet -f smslant "Updates"
echo
sudo pacman -Rns $(pacman -Qtdq)

$aur_helper -Scc
