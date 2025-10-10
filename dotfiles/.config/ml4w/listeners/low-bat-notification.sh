#!/bin/bash

BAT="/sys/class/power_supply/BAT1"
NOTIFIED_20=false
NOTIFIED_15=false

Simulate=18

while true; do
    CAPACITY=$(cat "$BAT/capacity")
    STATUS=$(cat "$BAT/status")

    if [[ "$STATUS" == "Discharging" ]]; then
        if [[ $Simulate -le 15 && $NOTIFIED_15 == false ]]; then
            notify-send -u critical "Battery Low" "Remaining: ${Simulate}%"
            NOTIFIED_15=true
        elif [[ $Simulate -le 20 && $Simulate -gt 15 && $NOTIFIED_20 == false ]]; then
            notify-send -u normal "Battery Low" "Remaining: ${Simulate}%"
            NOTIFIED_20=true
        elif [[ $Simulate -gt 20 ]]; then
            NOTIFIED_20=false
            NOTIFIED_15=false
        fi
    fi

    sleep 60
done
