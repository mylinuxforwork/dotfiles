#!/usr/bin/env bash
res_w=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
res_h=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
h_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
w_margin=$((res_h * 27 / h_scale))
wlogout -b 5 -T $w_margin -B $w_margin
