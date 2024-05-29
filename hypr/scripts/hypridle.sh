#!/bin/bash
SERVICE="hypridle"
if [[ "$1" == "status" ]]; then
    if pgrep -x "$SERVICE" >/dev/null ;then
        echo ":: $SERVICE is running"
    else
        echo ":: $SERVICE is not running"
    fi
fi

