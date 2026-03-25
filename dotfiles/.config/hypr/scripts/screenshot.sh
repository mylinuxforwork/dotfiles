#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# CONFIG
# --------------------------------------------------

SAVE_DIR="$(cat ~/.config/ml4w/settings/screenshot-folder)"
SAVE_FILENAME="$(cat ~/.config/ml4w/settings/screenshot-filename)"

eval SCREENSHOT_DIR="$SAVE_DIR"
eval FILENAME="$SAVE_FILENAME"

FULLPATH="${SCREENSHOT_DIR}/${FILENAME}"

mkdir -p "$SCREENSHOT_DIR"

# --------------------------------------------------
# ROFI
# --------------------------------------------------

rofi_menu() {
    rofi -dmenu -replace \
        -config ~/.config/rofi/config-screenshot.rasi \
        -i -no-show-icons -l 5 -width 30 -p "$1"
}

choose_mode() {
    echo -e "screen\noutput\narea" | rofi_menu "Capture mode"
}

choose_action() {
    echo -e "copy\nsave\ncopysave" | rofi_menu "Action"
}

choose_timer() {
    echo -e "0\n5\n10\n20\n30\n60" | rofi_menu "Delay (seconds)"
}

# --------------------------------------------------
# TIMER
# --------------------------------------------------

countdown() {
    local seconds="$1"
    while [[ "$seconds" -gt 0 ]]; do
        notify-send "Screenshot in $seconds s"
        sleep 1
        ((seconds--))
    done
}

# --------------------------------------------------
# EXECUTION
# --------------------------------------------------

run_capture() {
    local delay mode action

    delay="$(choose_timer)" || exit 0
    mode="$(choose_mode)" || exit 0
    action="$(choose_action)" || exit 0

    [[ "$delay" -gt 0 ]] && countdown "$delay"

    grimblast --notify "$action" "$mode" "$FULLPATH"
}

# --------------------------------------------------
# INSTANT MODES
# --------------------------------------------------

case "${1:-}" in
    --instant)
        grimblast --notify copysave screen "$FULLPATH"
        ;;
    --instant-area)
        grimblast --notify copysave area "$FULLPATH"
        ;;
    *)
        run_capture
        ;;
esac
