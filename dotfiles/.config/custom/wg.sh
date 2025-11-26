#!/usr/bin/env bash

INTERFACE="laptop"

case $1 in
    switch_state)
        if sudo wg show | grep -q "interface: $INTERFACE"; then
            sudo wg-quick down "$INTERFACE" && printf '{"text": "DOWN"}'
        else
            sudo wg-quick up "$INTERFACE" && printf '{"text": "UP"}'
        fi
        ;;

    status)
        if sudo wg show | grep -q "interface: $INTERFACE"; then
            TRAFFIC=$(sudo wg show | grep transfer)
            printf '{"text": "UP", "tooltip": "%s", "class": "green"}' "$TRAFFIC"
        else
            printf '{"text": "DOWN"}'
        fi
        ;;
esac

