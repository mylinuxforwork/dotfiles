#!/usr/bin/env bash

######################################
# Application Launcher with gum
######################################

# --- Configuration ---
INCLUDE_TERMINAL_APPS=true
DIRS=(
    "/usr/share/applications" 
    "$HOME/.local/share/applications"
    "/var/lib/flatpak/exports/share/applications"
    "$HOME/.local/share/flatpak/exports/share/applications"
)

trap "clear; exit" SIGINT
clear

# --- High-Speed Data Collection ---
LIST=$(find -L "${DIRS[@]}" -name "*.desktop" -type f -print0 2>/dev/null | xargs -0 awk -v include_term="$INCLUDE_TERMINAL_APPS" '
    BEGINFILE { 
        name=""; exec=""; is_term="false"; 
    }
    # Use index and substr to split only at the FIRST equals sign
    /^Name=/ { if (name == "") { i=index($0,"="); name=substr($0,i+1) } }
    /^Exec=/ { if (exec == "") { i=index($0,"="); exec=substr($0,i+1) } }
    /^Terminal=/ { i=index($0,"="); is_term=substr($0,i+1) }
    
    ENDFILE {
        # Cleanup placeholders and whitespace
        gsub(/%[a-zA-Z]/, "", exec);
        gsub(/^[ \t]+|[ \t]+$/, "", exec);
        gsub(/^[ \t]+|[ \t]+$/, "", name);

        if (name != "" && exec != "") {
            if (include_term == "true" || is_term != "true") {
                icon = (is_term == "true") ? " " : "󰀻 ";
                if (FILENAME ~ /flatpak/) icon = " ";
                
                # We use a unique separator sequence " || " to avoid pipe conflicts
                print icon " " name " || " exec;
            }
        }
    }
' | sort -u)

# --- UI Selection ---
SELECTED=$(echo "$LIST" | gum filter \
    --indicator="→" \
    --match.foreground="212" \
    --indicator.foreground="212" \
    --placeholder="Search Apps...")

clear

# --- Execution ---
if [ -n "$SELECTED" ]; then
    # Extract everything after the " || " separator
    CMD=$(echo "$SELECTED" | sed 's/.* || //')
    
    if [[ "$SELECTED" == " "* ]]; then
        TERM_BIN=$(command -v kitty || command -v alacritty || command -v xterm)
        $TERM_BIN -e $CMD & 
    else
        setsid bash -c "$CMD" >/dev/null 2>&1 &
    fi
    
    disown
    echo "🚀 Launching $CMD..."
    sleep 0.5
    clear
fi
