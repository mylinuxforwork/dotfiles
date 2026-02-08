#!/bin/bash
#    ____                
#   / __/__  ______ _____
#  / _// _ \/ __/ // (_-<
# /_/  \___/\__/\_,_/___/
#                       

# Ensure jq is installed
if ! command -v jq &> /dev/null
then
    echo "Error: 'jq' is not installed. Please install it to use this script."
    echo "  For Arch Linux: sudo pacman -S jq"
    echo "  For Debian/Ubuntu: sudo apt install jq"
    exit 1
fi

# Ensure awk is installed
if ! command -v awk &> /dev/null
then
    echo "Error: 'awk' is not installed. Please install it to use this script."
    echo "  For Arch Linux: sudo pacman -S gawk"
    echo "  For Debian/Ubuntu: sudo apt install gawk"
    exit 1
fi

# Get all open windows in JSON format
# Filter for mapped (visible) and non-hidden windows
# Format the output for Rofi: "Window Title --HYPRCTL_INFO--<address>--<workspace_id>"
# This allows Rofi to display the title, but the full string (with address and workspace) is passed on selection.
rofi_input=$(hyprctl clients -j | jq -r '.[] | select(.mapped == true and .hidden == false) | "\(.title) --HYPRCTL_INFO--\(.address)--\(.workspace.id)"')

# Check if there are any windows to display
if [ -z "$rofi_input" ]; then
    echo "No active windows found."
    exit 0
fi

# Pipe the formatted window list to Rofi
# -dmenu: Rofi's dmenu mode for selection
# -i: Case-insensitive searching
# -p "Active Window": Sets the Rofi prompt
selected_line=$(echo -e "$rofi_input" | rofi -dmenu -config ~/.config/rofi/config-compact.rasi -no-show-icons -i -p "Active Window")

# Check if a selection was made (user didn't press Esc or close Rofi)
if [ -n "$selected_line" ]; then
    # Extract the information we embedded: address and workspace ID
    # Using awk for more robust parsing of the selected line
    # This extracts everything AFTER the first occurrence of '--HYPRCTL_INFO--'
    info_raw=$(echo "$selected_line" | awk -F '--HYPRCTL_INFO--' '{print $2}')

    if [ -z "$info_raw" ]; then
        echo "Error: Could not parse window information from selected line. Delimiter not found or malformed input."
        echo "Selected Line was: '${selected_line}'"
        exit 1
    fi

    # Now split the info_raw by '--' to get the address and workspace ID
    selected_address=$(echo "$info_raw" | awk -F '--' '{print $1}')
    selected_workspace_id=$(echo "$info_raw" | awk -F '--' '{print $2}')

    # Trim any potential leading/trailing whitespace using xargs
    selected_address=$(echo "$selected_address" | xargs)
    selected_workspace_id=$(echo "$selected_workspace_id" | xargs)

    # Validate extracted values before dispatching
    if [[ -z "$selected_address" || -z "$selected_workspace_id" ]]; then
        echo "Error: Missing address or workspace ID after parsing."
        echo "Address: '${selected_address}', Workspace ID: '${selected_workspace_id}'"
        exit 1
    fi
    
    # Validate workspace ID is numeric
    if ! [[ "$selected_workspace_id" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid workspace ID format: '${selected_workspace_id}' (must be numeric)."
        exit 1
    fi

    # Switch to the selected window's workspace
    hyprctl dispatch workspace "$selected_workspace_id"

    # Add a small delay to ensure Hyprland processes the workspace change before focusing
    sleep 0.05 

    # Focus on the selected window using its unique address
    hyprctl dispatch focuswindow "address:$selected_address"
else
    echo "No window selected. Exiting."
fi