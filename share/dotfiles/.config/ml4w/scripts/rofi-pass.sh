#!/bin/bash


PASS_STORE="${1:-$HOME/.password-store}"
KEY_ICON="\uf511"  # Use a Nerd Font icon if preferred

# Find all KEYs and store full paths
mapfile -t KEY_LIST < <(
  find "$PASS_STORE" -type f -iname "*.gpg" |
  sed "s|^$PASS_STORE/||; s|\.gpg$||"
)

if [ ${#KEY_LIST[@]} -eq 0 ]; then
    notify-send "No KEY files found in $SEARCH_DIR"
    exit 1
fi

declare -A KEY_MAP

# Extract only keynames and store them in the map with icons
for KEY in "${KEY_LIST[@]}"; do
    TRIMMED_NAME=$(echo "$KEY" | awk '{$1=$1};1')  # Removes leading & trailing spaces
    DISPLAY_NAME=$(echo -e "$KEY_ICON   $TRIMMED_NAME")
    KEY_MAP["$DISPLAY_NAME"]="$KEY"
done

# Show sorted keynames with icons in a SINGLE COLUMN in Rofi
CHOSEN_NAME=$(printf "%s\n" "${!KEY_MAP[@]}" | sort -V | rofi -dmenu -i -p "Elije contraseña" -format "s" -columns 1)

# Remove the icon from the name
TRIMMED_CHOSEN_NAME=$(echo "$CHOSEN_NAME" | awk '{$1=""; sub(/^ /, ""); print}')

# Copy selected password to the clipboard
if [ -n "$TRIMMED_CHOSEN_NAME" ]; then
    pass -c "$TRIMMED_CHOSEN_NAME"
fi
