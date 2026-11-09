#!/usr/bin/env bash

CACHE_DIR="${BRIGHTNESS_CACHE_DIR:-/tmp/ml4w-brightness}"
DISPLAYS_TTL=30
BRIGHTNESS_TTL=15
DAEMON_INTERVAL=10

get_mode() {
    if ls /sys/class/backlight/* >/dev/null 2>&1; then
        echo "backlight"
    else
        echo "ddc"
    fi
}

MODE=$(get_mode)

cache_read() {
    local key="$1" ttl="$2"
    local file="$CACHE_DIR/$key" ts="$CACHE_DIR/$key.ts"
    [ -f "$file" ] && [ -f "$ts" ] || return 1
    local age=$(( $(date +%s) - $(cat "$ts") ))
    [ "$age" -ge "$ttl" ] && return 1
    cat "$file"
}

cache_write() {
    local key="$1" value="$2"
    mkdir -p "$CACHE_DIR"
    printf '%s\n' "$value" > "$CACHE_DIR/$key"
    date +%s > "$CACHE_DIR/$key.ts"
}

detect_displays() {
    local count
    count=$(ddcutil detect | grep -c "Display")
    cache_write displays "$count"
    echo "$count"
}

get_displays() {
    local cached
    cached=$(cache_read displays "$DISPLAYS_TTL") && { echo "$cached"; return; }
    detect_displays
}

read_brightness() {
    local display="$1" value
    value=$(ddcutil --display "$display" getvcp 10 | grep -oP 'current value =\s*\K\d+')
    cache_write "display-$display" "$value"
    echo "$value"
}

get_brightness() {
    local display="$1" cached
    cached=$(cache_read "display-$display" "$BRIGHTNESS_TTL") && { echo "$cached"; return; }
    read_brightness "$display"
}

apply_brightness() {
    local display="$1" value="$2"
    ddcutil --display "$display" setvcp 10 "$value" >/dev/null 2>&1
    cache_write "display-$display" "$value"
}

set_all() {
    local value="$1" count pids=() d p
    count=$(get_displays)
    for d in $(seq 1 "$count"); do
        ( apply_brightness "$d" "$value" ) &
        pids+=("$!")
    done
    for p in "${pids[@]:-}"; do wait "$p" 2>/dev/null; done
}

delta_all() {
    local delta="$1" count pids=() d current new p
    count=$(get_displays)
    for d in $(seq 1 "$count"); do
        current=$(get_brightness "$d")
        new=$((current + delta))
        [ "$new" -gt 100 ] && new=100
        [ "$new" -lt 0 ] && new=0
        ( apply_brightness "$d" "$new" ) &
        pids+=("$!")
    done
    for p in "${pids[@]:-}"; do wait "$p" 2>/dev/null; done
}

refresh_all() {
    local count pids=() d p
    count=$(get_displays)
    for d in $(seq 1 "$count"); do
        get_brightness "$d" >/dev/null &
        pids+=("$!")
    done
    for p in "${pids[@]:-}"; do wait "$p" 2>/dev/null; done
}

print_status() {
    if [ "$MODE" = "backlight" ]; then
        local value
        value=$(brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}' | head -1)
        echo "displays=1"
        echo "display1=${value:-0}"
        return
    fi
    local count d
    count=$(get_displays)
    echo "displays=$count"
    for d in $(seq 1 "$count"); do
        echo "display$d=$(get_brightness "$d")"
    done
}

shorthand_delta() {
    local delta="$1"
    if [ "$MODE" = "backlight" ]; then
        case "$delta" in
            -*) sign="-" ; val="${delta#-}" ;;
            *)  sign="+" ; val="${delta#+}" ;;
        esac
        brightnessctl set "${val}%${sign}"
    else
        delta_all "$delta"
    fi
}

run_daemon() {
    [ "$MODE" = "ddc" ] || exit 0
    mkdir -p "$CACHE_DIR"
    if [ -f "$CACHE_DIR/daemon.pid" ] && kill -0 "$(cat "$CACHE_DIR/daemon.pid" 2>/dev/null)" 2>/dev/null; then
        exit 0
    fi
    echo $$ > "$CACHE_DIR/daemon.pid"
    trap 'rm -f "$CACHE_DIR/daemon.pid"; exit 0' TERM INT
    refresh_all >/dev/null 2>&1
    while true; do
        sleep "$DAEMON_INTERVAL"
        refresh_all >/dev/null 2>&1
    done
}

case "$1" in

displays)
    if [ "$MODE" = "backlight" ]; then
        echo 1
    else
        get_displays
    fi
;;

get)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}'
    else
        get_brightness 1
    fi
;;

get-display)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}'
    else
        get_brightness "$2"
    fi
;;

set)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl set "$2%"
    else
        set_all "$2"
    fi
;;

set-percentage)
    if [ "$MODE" = "backlight" ]; then
        case "$2" in
            -*) sign="-" ; val="${2#-}" ;;
            *)  sign="+" ; val="${2#+}" ;;
        esac
        brightnessctl set "${val}%${sign}"
    else
        delta_all "$2"
    fi
;;

set-display)
    if [ "$MODE" = "backlight" ]; then
        brightnessctl set "$3%"
    else
        apply_brightness "$2" "$3"
    fi
;;

set-display-percentage)
    if [ "$MODE" = "backlight" ]; then
        case "$3" in
            -*) sign="-" ; val="${3#-}" ;;
            *)  sign="+" ; val="${3#+}" ;;
        esac
        brightnessctl set "${val}%${sign}"
    else
        d="$2"
        delta="$3"
        current=$(get_brightness "$d")
        new=$((current + delta))
        [ "$new" -gt 100 ] && new=100
        [ "$new" -lt 0 ] && new=0
        apply_brightness "$d" "$new"
    fi
;;

status)
    print_status
;;

refresh)
    if [ "$MODE" = "ddc" ]; then
        refresh_all
    fi
;;

daemon)
    run_daemon
;;

*)
    case "$1" in
        -*|+*|[0-9]*)
            shorthand_delta "$1"
        ;;
        *)
            echo "usage: $0 {displays|get|get-display|set|set-percentage|set-display|set-display-percentage|status|refresh|daemon|N}" >&2
            exit 1
        ;;
    esac
;;

esac