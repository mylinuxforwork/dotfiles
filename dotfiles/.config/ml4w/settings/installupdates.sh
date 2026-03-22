#!/usr/bin/env bash
TERMINAL=$(cat ~/.config/ml4w/settings/terminal.sh)
if [ $TERMINAL == "ghostty" ]; then
    ghostty --class=dotfiles-floating -e ~/.config/ml4w/scripts/ml4w-install-system-updates
else
    $(cat ~/.config/ml4w/settings/terminal.sh) --class dotfiles-floating -e ~/.config/ml4w/scripts/ml4w-install-system-updates
fi
