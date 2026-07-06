#!/bin/bash

# If a Quickshell overlay panel is open, close it instead of killing the
# window behind it (SUPER+Q should not reach the background window).
for panel in sidebar wallpaper calendar; do
    if [ "$(qs ipc call "$panel" isOpen 2>/dev/null)" = "true" ]; then
        qs ipc call "$panel" close
        exit 0
    fi
done

# Fetch the active window data as JSON and extract the title
ACTIVE_TITLE=$(hyprctl activewindow -j | jq -r '.title')

# Exit silently if no window is currently active
if [ -z "$ACTIVE_TITLE" ] || [ "$ACTIVE_TITLE" == "null" ]; then
    exit 0
fi

# Determine the action based on the window's title
case "$ACTIVE_TITLE" in
    "ML4W Welcome")
        qs ipc call welcome toggle
        ;;
    "ML4W Dotfiles Settings")
        qs -p $HOME/.local/share/ml4w-dotfiles-settings/quickshell ipc call settings toggle
        ;;
    *)
        # Updated for Hyprland 0.55+ Lua dispatcher syntax
        hyprctl dispatch 'hl.dsp.window.close()'
        ;;
esac