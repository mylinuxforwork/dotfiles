#!/bin/bash

BAT=$(command ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)
if [[ -z "$BAT" ]]; then
    exit 0
fi

NOTIFIED_20=false
NOTIFIED_15=false

while true; do
    CAPACITY=$(cat "$BAT/capacity")
    STATUS=$(cat "$BAT/status")

    if [[ "$STATUS" == "Discharging" ]]; then
        if [[ $CAPACITY -le 15 && $NOTIFIED_15 == false ]]; then
            notify-send -u critical "Battery Low" "Remaining: ${CAPACITY}%"
            NOTIFIED_15=true
        elif [[ $CAPACITY -le 20 && $CAPACITY -gt 15 && $NOTIFIED_20 == false ]]; then
            notify-send -u normal "Battery Low" "Remaining: ${CAPACITY}%"
            NOTIFIED_20=true
        elif [[ $CAPACITY -gt 20 ]]; then
            NOTIFIED_20=false
            NOTIFIED_15=false
        fi
    else
        NOTIFIED_20=false
        NOTIFIED_15=false
    fi

    sleep 60
done
