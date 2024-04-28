#!/bin/bash
FILE="$HOME/.cache/ml4w_sidebar"
CFG="$HOME/dotfiles/eww/ml4w-sidebar"
EWW=`which eww`

if [[ ! `pidof eww` ]]; then
	${EWW} daemon
	sleep 0.5
fi

sc=$($HOME/dotfiles/.settings/eww-monitor.sh)
if [[ ! -f "$FILE" ]]; then
	touch "$FILE"
	echo ":: Opening on Monitor $sc"
	${EWW} --config "$CFG" open ml4wlauncher --screen $sc
	${EWW} --config "$CFG" open resources --screen $sc
	${EWW} --config "$CFG" open logout --screen $sc
	${EWW} --config "$CFG" open suspend --screen $sc
	${EWW} --config "$CFG" open lock --screen $sc
	${EWW} --config "$CFG" open reboot --screen $sc
	${EWW} --config "$CFG" open shutdown --screen $sc
	${EWW} --config "$CFG" open close --screen $sc
else
	${EWW} --config "$CFG" close resources ml4wlauncher logout suspend lock reboot shutdown close
	echo ":: Closing widgets"
	rm "$FILE"
fi