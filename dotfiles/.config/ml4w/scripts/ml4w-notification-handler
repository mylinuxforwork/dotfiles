#!/usr/bin/env bash

DEFAULT_ICON="notifications-symbolic"

notify_user() {
    local icon="$DEFAULT_ICON"
    local urgency="low"
    local time=""
    local app=""
    local summary=""
    local message=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
        --icon|--i|-i)
            icon="$2"
            shift 2
            ;;
        --urgency|--u|-u)
            urgency="$2"
            shift 2
            ;;
        --app|--a|-a)
            app="$2"
            shift 2
            ;;
        --time|--t|-t)
            time="$2"
            shift 2
            ;;
        --summary|--s|-s)
            summary="$2"
            shift 2
            ;;
        --message|--m|-m)
            message="$2"
            shift 2
            ;;
        --extra|--e|-e)
            # split string into words
            read -r -a extra <<< "$2"
            shift 2
            ;;
        *)
            echo "notify_user: unknown option: $1" >&2
            return 1
            ;;
        esac
    done

    # ---- Mandatory argument checks ----
    if [[ -z "$summary" && -z "$app" ]]; then
        echo "notify_user: --summary or --app is required" >&2
        return 1
    fi

    # ---- Normalize summary/app ----
    [[ -z "$summary" ]] && summary="$app"
    [[ -z "$app"   ]] && app="$summary"

    # ---- Icon validation ----
    if [[ "$icon" != "$DEFAULT_ICON" ]]; then
        if [[ -f "$icon" && "$icon" =~ \.(png|svg)$ ]]; then
            :
        elif [[ ! "$icon" =~ / ]]; then
            :
        else
            icon="$DEFAULT_ICON"
        fi
    fi

    local notify_args=(
        -u "$urgency"
        -i "$icon"
        -a "$app"
    )

    # Uses expiry time if informed
    [[ -n "$time" ]] && notify_args+=(-t "$time")
    # Uses other params as is
    [[ ${#extra[@]} -gt 0 ]] && notify_args+=("${extra[@]}")

    notify-send "${notify_args[@]}" "$summary" "$message"

}