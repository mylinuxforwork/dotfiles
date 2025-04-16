#!/bin/bash

SEARCH_DIR="${1:-$HOME/Documents/lectura}"
PDF_ICON="\uf1c1"  # Use a Nerd Font icon if preferred

# Find all PDFs and store full paths
mapfile -t PDF_LIST < <(find "$SEARCH_DIR" -type f -iname "*.pdf")

if [ ${#PDF_LIST[@]} -eq 0 ]; then
    notify-send "No PDF files found in $SEARCH_DIR"
    exit 1
fi

declare -A PDF_MAP

# Extract only filenames and store them in the map with icons
for PDF in "${PDF_LIST[@]}"; do
    FILENAME=$(basename "$PDF")
    TRIMMED_NAME=$(echo "$FILENAME" | awk '{$1=$1};1')  # Removes leading & trailing spaces
    DISPLAY_NAME=$(echo -e "$PDF_ICON     $TRIMMED_NAME")
    PDF_MAP["$DISPLAY_NAME"]="$PDF"
done

# Show sorted filenames with icons in a SINGLE COLUMN in Rofi
CHOSEN_NAME=$(printf "%s\n" "${!PDF_MAP[@]}" | sort -V | rofi -dmenu -i -p "Select PDF" -format "s" -columns 1)

# Open the selected file
if [ -n "$CHOSEN_NAME" ]; then
    zathura "${PDF_MAP[$CHOSEN_NAME]}" &
fi
