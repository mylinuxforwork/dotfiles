#!/bin/bash

sleep 0.3
$HOME/dotfiles/eww/ml4w-sidebar/launch.sh

if [[ "$1" == "reboot" ]]; then
	$HOME/dotfiles/hypr/scripts/reboot.sh
elif [[ "$1" == "shutdown" ]]; then
	$HOME/dotfiles/hypr/scripts/shutdown.sh
elif [[ "$1" == "lock" ]]; then
	$HOME/dotfiles/hypr/scripts/lock.sh
elif [[ "$1" == "suspend" ]]; then
	$HOME/dotfiles/hypr/scripts/suspend.sh
elif [[ "$1" == "logout" ]]; then
	$HOME/dotfiles/hypr/scripts/exit.sh
fi
