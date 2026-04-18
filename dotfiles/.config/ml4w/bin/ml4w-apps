#!/usr/bin/env bash

# ------------------------------------------
# CLI Application Launcher
# ------------------------------------------

# --- Configuration ---
INCLUDE_TERMINAL_APPS=true
DIRS=("/usr/share/applications" "$HOME/.local/share/applications")
FLATPAK_SYM="󰏖"  # Distinct icon for all Flatpaks
FLATPAK_ICON="$FLATPAK_SYM "  # Distinct icon for all Flatpaks

# --- 1. Collect Standard Apps (AWK) ---
LIST=$(find -L "${DIRS[@]}" -name "*.desktop" -type f 2>/dev/null | xargs awk -F'=' -v inc_term="$INCLUDE_TERMINAL_APPS" '
    function print_entry() {
        if (name != "" && exec != "") {
            if (inc_term == "true" || is_term != "true") {
                icon = (is_term == "true") ? " " : "󰀻 ";
                printf "%s %s | %s | %s\n", icon, name, exec, f
            }
        }
    }
    f != FILENAME { print_entry(); f = FILENAME; name = ""; exec = ""; is_term = "false"; }
    /^Name=/     { if (!name) { sub(/^Name=/, ""); name = $0 } }
    /^Exec=/     { if (!exec) { sub(/^Exec=/, ""); exec = $0; gsub(/%[a-zA-Z]/, "", exec) } }
    /^Terminal=/ { sub(/^Terminal=/, ""); is_term = tolower($0) }
    END { print_entry() }
' 2>/dev/null)

# --- 2. Collect Flatpaks (Direct Query) ---
if command -v flatpak >/dev/null 2>&1; then
    while IFS=$'\t' read -r id fp_name; do
        [ -z "$id" ] && continue
        
        fp_file=$(find /var/lib/flatpak/exports/share/applications/ ~/.local/share/flatpak/exports/share/applications/ -name "$id.desktop" 2>/dev/null | head -n 1)
        
        if [ -n "$fp_file" ]; then
            fp_exec=$(grep -m 1 "^Exec=" "$fp_file" | cut -d= -f2- | sed "s/%[a-zA-Z]//g" | xargs)
            LIST+=$'\n'"$FLATPAK_ICON $fp_name | $fp_exec | $fp_file"
        fi
    done < <(flatpak list --app --columns=application,name 2>/dev/null)
fi

# --- 3. UI Selection (Preview Removed) ---
SELECTED=$(echo "$LIST" | grep . | sort -u | fzf \
    --style full \
    --delimiter '|' \
    --with-nth '1,2' \
    --height 40% \
    --layout reverse \
    --border \
    --prompt "🚀 Run: " \
    --header "󰀻 System | 󰏖 Flatpak |   Terminal")

# --- 4. Launch ---
if [ -n "$SELECTED" ]; then
    CMD=$(echo "$SELECTED" | cut -d'|' -f2 | xargs)
    setsid $CMD >/dev/null 2>&1 &
    exit 0
fi