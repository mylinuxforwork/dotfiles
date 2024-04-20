#!/bin/bash
FILE="$HOME/.cache/ml4w_sidebar"
CFG="$HOME/dotfiles/eww/ml4w-sidebar"
EWW=`which eww`

if [[ ! `pidof eww` ]]; then
	${EWW} daemon
	sleep 0.5
fi

if [[ ! -f "$FILE" ]]; then
	touch "$FILE"
	${EWW} --config "$CFG" open-many ml4wlauncher resources logout suspend lock reboot shutdown
else
	${EWW} --config "$CFG" close resources ml4wlauncher logout suspend lock reboot shutdown
	rm "$FILE"
fi