#!/bin/bash
clear
aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"
figlet -f smslant "Cleanup"
echo
$aur_helper -Scc
