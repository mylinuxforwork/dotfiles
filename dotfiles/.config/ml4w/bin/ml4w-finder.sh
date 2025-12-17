#!/usr/bin/env bash

# ------------------------------------------
# CLI Fuzzy Finder
# ------------------------------------------

# --- 1. Generate List with find's internal type check ---
# %y = type (d=dir, f=file), %p = path
LIST=$(find -L . -maxdepth 4 -printf "%y %p\n" 2>/dev/null | awk '
    $1 == "d" { print " " $2 }
    $1 == "f" { print "󰈚 " $2 }
    $1 == "l" { print " " $2 }
' | grep -v " \./$")

# --- 2. UI Selection ---
SELECTED_RAW=$(echo "$LIST" | fzf \
    --style full \
    --height 50% \
    --layout reverse \
    --border \
    --prompt "🔍 Finder: " \
    --with-nth 2..)

[ -z "$SELECTED_RAW" ] && exit 0

# --- 3. Output logic for the wrapper function ---
TYPE_ICON=$(echo "$SELECTED_RAW" | cut -d' ' -f1)
PATH_VAL=$(echo "$SELECTED_RAW" | cut -d' ' -f2-)

if [ "$TYPE_ICON" == "" ]; then
    echo "TYPE_DIR:$PATH_VAL"
else
    echo "TYPE_FILE:$PATH_VAL"
    ${EDITOR:-nano} "$PATH_VAL"
fi