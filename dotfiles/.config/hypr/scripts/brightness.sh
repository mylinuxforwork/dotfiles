#!/usr/bin/env bash

get_mode() {
    if ls /sys/class/backlight/* >/dev/null 2>&1; then
        echo "backlight"
    else
        echo "ddc"
    fi
}

MODE=$(get_mode)

case "$1" in

displays)
    if [ "$MODE" = "backlight" ]; then
        echo 1
    else
        ddcutil detect | grep "Display" | wc -l
    fi
;;

get)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}'
    else
        ddcutil getvcp 10 | grep -oP 'current value =\s*\K\d+' | head -1
    fi
;;

get-display)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}'
    else
        ddcutil --display "$2" getvcp 10 | grep -oP 'current value =\s*\K\d+'
    fi
;;

set)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl set "$2%"
    else
        for d in $(seq 1 $(ddcutil detect | grep Display | wc -l)); do
            ddcutil --display "$d" setvcp 10 "$2"
        done
    fi
;;

set-percentage)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl set "$2%"
    else
        for d in $(seq 1 $(ddcutil detect | grep Display | wc -l)); do
            current=$(ddcutil --display "$d" getvcp 10 | grep -oP 'current value =\s*\K\d+')
            new=$((current + $2))

            [ "$new" -gt 100 ] && new=100
            [ "$new" -lt 0 ] && new=0

            ddcutil --display "$d" setvcp 10 "$new"
        done
    fi
;;

set-display)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl set "$3%"
    else
        ddcutil --display "$2" setvcp 10 "$3"
    fi
;;

set-display-percentage)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl set "$3%"
    else
        delta="$3"
        current=$(ddcutil --display "$2" getvcp 10 | grep -oP 'current value =\s*\K\d+')
        new=$((current + delta))

        [ "$new" -gt 100 ] && new=100
        [ "$new" -lt 0 ] && new=0

        ddcutil --display "$2" setvcp 10 "$new"
    fi

esac
