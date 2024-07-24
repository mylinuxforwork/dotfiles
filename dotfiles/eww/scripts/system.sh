#!/bin/bash
FILE="$HOME/.cache/ml4w_sidebar"
sleep 0.3
$HOME/dotfiles/eww/ml4w-sidebar/launch.sh
sleep 2
# Rebbot
if [[ "$1" == "reboot" ]]; then
	$HOME/dotfiles/hypr/scripts/reboot.sh
# Shutdown
elif [[ "$1" == "shutdown" ]]; then
	$HOME/dotfiles/hypr/scripts/shutdown.sh
#Lock
elif [[ "$1" == "lock" ]]; then
	$HOME/dotfiles/hypr/scripts/lock.sh
#Suspend
elif [[ "$1" == "suspend" ]]; then
	$HOME/dotfiles/hypr/scripts/suspend.sh
#Logout
elif [[ "$1" == "logout" ]]; then
	$HOME/dotfiles/hypr/scripts/exit.sh
fi
