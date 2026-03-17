#!/usr/bin/env bash
# --------------------------------------------------------------
# ML4W Apps
# --------------------------------------------------------------

echo ":: Installing the ML4W Apps"

flatpak update

ml4w_app="com.ml4w.calendar"
ml4w_app_repo="dotfiles-calendar"
echo ":: Installing $ml4w_app"
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/$ml4w_app_repo/master/setup.sh)"

