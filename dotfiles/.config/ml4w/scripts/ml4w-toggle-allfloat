#!/usr/bin/env bash
ws_id=$(hyprctl activeworkspace -j | jq -r '.id')
mapfile -t addresses < <(
    hyprctl clients -j | jq -r --argjson ws "$ws_id" '.[] | select(.workspace.id == $ws) | .address'
)
for addr in "${addresses[@]}"; do
    hyprctl dispatch togglefloating "address:$addr"
done