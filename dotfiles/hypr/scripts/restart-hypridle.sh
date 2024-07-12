#!/bin/bash
killall hypridle
sleep 1
hypridle &
notify-send "hypridle has been restarted."