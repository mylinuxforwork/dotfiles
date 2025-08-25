#!/usr/bin/env bash
if [ -f $HOME/.local/bin/waypaper ]; then
    $HOME/.local/bin/waypaper
else
    waypaper
fi