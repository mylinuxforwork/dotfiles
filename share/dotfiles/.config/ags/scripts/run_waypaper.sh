#!/bin/bash
echo "Run Waypaper"
waypaper
sleep 3
killall -SIGUSR2 waybar