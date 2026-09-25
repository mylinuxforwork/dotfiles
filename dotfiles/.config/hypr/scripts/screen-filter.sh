#!/usr/bin/env bash

set -Eeuo pipefail

SHADER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/shaders"
STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/screen-filter"
APP_NAME="Screen Filter"
NOTIFICATION_ID="screen-filter"

if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] || ! command -v hyprctl >/dev/null 2>&1; then
  echo "Error: Hyprland instance not detected or hyprctl missing." >&2
  exit 1
fi

mkdir -p "$SHADER_DIR"

notify() {
  local title="$1"
  local msg="$2"
  local icon="${3:-video-display}"
  local timeout="${4:-1500}"

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "$title" "$msg" \
      -a "$APP_NAME" \
      -i "$icon" \
      -h "string:x-canonical-private-synchronous:$NOTIFICATION_ID" \
      -t "$timeout" 2>/dev/null || true
  fi
}

save_state() {
  local filter_name="$1"
  mkdir -p "$(dirname "$STATE_FILE")" 2>/dev/null || true
  echo "$filter_name" > "$STATE_FILE" 2>/dev/null || true
}

apply_shader() {
  local target="${1:-}"
  hyprctl eval "hl.config({ decoration = { screen_shader = '$target' } })" >/dev/null 2>&1 || \
  hyprctl keyword decoration:screen_shader "$target" >/dev/null 2>&1
}

get_active_shader() {
  local path
  path=$(hyprctl getoption decoration:screen_shader 2>/dev/null | awk -F': ' '/str:/ {print $2}' | tr -d '[]' | xargs)
  if [[ -n "$path" && "$path" != "EMPTY" && "$path" != "null" ]]; then
    echo "$path"
  else
    echo ""
  fi
}

get_available_filters() {
  local available=("none")
  local default_order=("greyscale" "nightlight" "sepia" "invert-colors")

  for name in "${default_order[@]}"; do
    if [[ -f "$SHADER_DIR/${name}.frag" || -f "$SHADER_DIR/${name}.glsl" ]]; then
      available+=("$name")
    fi
  done

  while IFS= read -r -d '' file; do
    local base
    base="$(basename "$file")"
    base="${base%.*}"

    local exists=0
    for item in "${available[@]}"; do
      if [[ "$item" == "$base" ]]; then
        exists=1
        break
      fi
    done
    [[ $exists -eq 0 ]] && available+=("$base")
  done < <(find "$SHADER_DIR" -maxdepth 1 \( -name "*.frag" -o -name "*.glsl" \) -print0 2>/dev/null)

  printf '%s\n' "${available[@]}"
}

resolve_shader_file() {
  local name="$1"
  if [[ -f "$SHADER_DIR/${name}.frag" ]]; then
    echo "$SHADER_DIR/${name}.frag"
  elif [[ -f "$SHADER_DIR/${name}.glsl" ]]; then
    echo "$SHADER_DIR/${name}.glsl"
  else
    echo ""
  fi
}

format_title() {
  local raw="$1"
  if [[ "$raw" == "none" ]]; then
    echo "Turn Off (Disabled)"
    return
  fi
  if [[ "$raw" == "greyscale" ]]; then
    echo "Grayscale"
    return
  fi
  if [[ "$raw" =~ ^blue-light-filter-([0-9]+)$ ]]; then
    echo "Blue Light Filter (${BASH_REMATCH[1]}%)"
    return
  fi
  echo "$raw" | sed -E 's/[-_]+/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
}

cycle_filter() {
  mapfile -t FILTERS < <(get_available_filters)

  if (( ${#FILTERS[@]} <= 1 )); then
    apply_shader ""
    save_state "none"
    notify "🖥️ $APP_NAME" "No shader files found in $SHADER_DIR" "dialog-warning" 2500
    exit 0
  fi

  local current_path
  current_path="$(get_active_shader)"
  local current_filter="none"

  if [[ -n "$current_path" ]]; then
    local filename
    filename="$(basename "$current_path")"
    current_filter="${filename%.*}"
  fi

  local current_idx=0
  for i in "${!FILTERS[@]}"; do
    if [[ "${FILTERS[$i]}" == "$current_filter" ]]; then
      current_idx=$i
      break
    fi
  done

  local next_idx=$(( (current_idx + 1) % ${#FILTERS[@]} ))
  local next_filter="${FILTERS[$next_idx]}"

  if [[ "$next_filter" == "none" ]]; then
    apply_shader ""
    save_state "none"
    notify "🖥️ $APP_NAME" "Filter Disabled" "video-display" 1500
  else
    local target_file
    target_file="$(resolve_shader_file "$next_filter")"
    if [[ -n "$target_file" && -f "$target_file" ]]; then
      apply_shader "$target_file"
      save_state "$next_filter"
      local display_name
      display_name="$(format_title "$next_filter")"
      notify "🖥️ $APP_NAME" "Active: $display_name" "video-display" 1500
    else
      apply_shader ""
      save_state "none"
      notify "🖥️ $APP_NAME" "Filter Disabled (Missing File)" "dialog-warning" 2000
    fi
  fi
}

rofi_menu() {
  if ! command -v rofi >/dev/null 2>&1; then
    echo "Error: rofi is not installed." >&2
    exit 1
  fi

  mapfile -t available_raw < <(get_available_filters)
  if (( ${#available_raw[@]} == 0 )); then
    notify "🖥️ $APP_NAME" "No shader files found in $SHADER_DIR" "dialog-warning" 2500
    exit 0
  fi

  local current_path
  current_path="$(get_active_shader)"
  local current_filter="none"
  if [[ -n "$current_path" ]]; then
    local filename
    filename="$(basename "$current_path")"
    current_filter="${filename%.*}"
  fi

  local rofi_lines=()
  local mapping=()
  local active_idx=0

  for idx in "${!available_raw[@]}"; do
    local name="${available_raw[$idx]}"
    local display
    display="$(format_title "$name")"

    if [[ "$name" == "$current_filter" ]]; then
      active_idx=$idx
      display="✓  $display (Active)"
    else
      display="   $display"
    fi

    rofi_lines+=("$display")
    mapping+=("$name")
  done

  local rofi_theme_arg=()
  local rofi_dir="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
  if [[ -f "$rofi_dir/config-compact.rasi" ]]; then
    rofi_theme_arg=(-config "$rofi_dir/config-compact.rasi")
  elif [[ -f "$rofi_dir/config-short.rasi" ]]; then
    rofi_theme_arg=(-config "$rofi_dir/config-short.rasi")
  elif [[ -f "$rofi_dir/config.rasi" ]]; then
    rofi_theme_arg=(-config "$rofi_dir/config.rasi")
  fi

  local lines_count=${#rofi_lines[@]}
  local selected_idx
  selected_idx=$(printf '%s\n' "${rofi_lines[@]}" | rofi -dmenu -i -replace "${rofi_theme_arg[@]}" -no-show-icons -l "$lines_count" -p "Screen Filter" -selected-row "$active_idx" -format "i" 2>/dev/null || true)

  if [[ -z "$selected_idx" ]]; then
    exit 0
  fi

  local chosen="${mapping[$selected_idx]}"
  if [[ "$chosen" == "none" ]]; then
    apply_shader ""
    save_state "none"
    notify "🖥️ $APP_NAME" "Filter Disabled" "video-display" 1500
  else
    local target_file
    target_file="$(resolve_shader_file "$chosen")"
    if [[ -n "$target_file" && -f "$target_file" ]]; then
      apply_shader "$target_file"
      save_state "$chosen"
      local display_name
      display_name="$(format_title "$chosen")"
      notify "🖥️ $APP_NAME" "Active: $display_name" "video-display" 1500
    fi
  fi
}

restore_state() {
  if [[ -f "$STATE_FILE" ]]; then
    local saved_filter
    saved_filter=$(<"$STATE_FILE")
    if [[ -n "$saved_filter" && "$saved_filter" != "none" ]]; then
      local target_file
      target_file="$(resolve_shader_file "$saved_filter")"
      if [[ -n "$target_file" && -f "$target_file" ]]; then
        apply_shader "$target_file"
        exit 0
      fi
    fi
  fi
  apply_shader ""
}

case "${1:-cycle}" in
  cycle|next)
    cycle_filter
    ;;
  -m|--menu|menu|rofi)
    rofi_menu
    ;;
  restore|init)
    restore_state
    ;;
  off|none|clear|disable)
    apply_shader ""
    save_state "none"
    notify "🖥️ $APP_NAME" "Filter Disabled" "video-display" 1500
    ;;
  status)
    active="$(get_active_shader)"
    if [[ -n "$active" ]]; then
      echo "Active shader: $(basename "$active") ($active)"
    else
      echo "Active shader: None (Disabled)"
    fi
    ;;
  list)
    echo "Available shaders in $SHADER_DIR:"
    get_available_filters
    ;;
  set|on)
    if [[ -z "${2:-}" ]]; then
      echo "Usage: $(basename "$0") set <shader_name>" >&2
      exit 1
    fi
    target_file="$(resolve_shader_file "$2")"
    if [[ -n "$target_file" ]]; then
      apply_shader "$target_file"
      save_state "$2"
      display_name="$(format_title "$2")"
      notify "🖥️ $APP_NAME" "Active: $display_name" "video-display" 1500
    else
      echo "Error: Shader '$2' not found in $SHADER_DIR" >&2
      exit 1
    fi
    ;;
  -h|--help|help)
    cat <<EOF
Usage: $(basename "$0") [COMMAND]

Commands:
  cycle, next       Cycle to the next available screen filter (default)
  -m, --menu, rofi  Open interactive Rofi shader picker
  restore, init     Restore saved shader state on system startup (silent)
  off, disable      Turn off screen shader
  set <name>        Directly enable a specific shader
  status            Show currently active shader
  list              List all discoverable shaders
  help, -h          Show this help message
EOF
    ;;
  *)
    echo "Unknown argument: $1. Use --help for usage." >&2
    exit 1
    ;;
esac
