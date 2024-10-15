#!/bin/bash
if [[ "$1" == "stop" ]]; then
    killall nm-applet
else
    nm-applet --indicator &
fi
