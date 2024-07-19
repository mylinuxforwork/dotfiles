#!/bin/bash
FILE="$HOME/.cache/ml4w_sidebar"
CFG="$HOME/dotfiles/eww/ml4w-sidebar"
EWW=`which eww`

if [[ ! `pidof eww` ]]; then
	${EWW} daemon
	sleep 0.5
fi

if [ -f $HOME/dotfiles/.settings/eww-monitor.sh ] && [ $(cat $HOME/dotfiles/.settings/eww-monitor.sh) != "auto" ] ;then
	echo ":: Using monitor id from $HOME/dotfiles/.settings/eww-monitor.sh"
	sc=$(cat $HOME/dotfiles/.settings/eww-monitor.sh)
else
	echo ":: Autodetect current focused monitor."
	sc=$(python $HOME/dotfiles/hypr/scripts/active-monitor.py)
fi
if [[ ! -f "$FILE" ]]; then
	touch "$FILE"
	echo ":: Opening on Monitor $sc"
	${EWW} --config "$CFG" open ml4wlauncher --force-wayland --screen $sc
	${EWW} --config "$CFG" open close --force-wayland --screen $sc
else
	${EWW} --config "$CFG" close ml4wlauncher close
	echo ":: Closing widgets"
	rm "$FILE"
fi