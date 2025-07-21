#!/bin/bash
#                              __    __
#   ___  __ _  ___ ____  ___  / /__ / /_
#  / _ \/  ' \/ _ `/ _ \/ _ \/ / -_) __/
# /_//_/_/_/_/\_,_/ .__/ .__/_/\__/\__/
#                /_/  /_/
#
if [[ "$1" == "stop" ]]; then
    killall nm-applet
elif [[ "$1" == "toggle" ]]; then
    if pgrep -x "nm-applet" >/dev/null; then
        echo "Running"
        killall nm-applet
    else
        echo "Stopped"
        nm-applet --indicator &
    fi
else
    nm-applet --indicator &
fi
