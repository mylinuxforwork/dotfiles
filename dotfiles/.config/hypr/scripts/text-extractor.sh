#!/usr/bin/env bash
# Script by https://github.com/anshifmonz

set -Eeuo pipefail

PICKER_PID=""
SLURP_TIMEOUT=10
DEPS=(grim slurp magick tesseract wl-copy timeout)

die() { echo "Error: $*" >&2; exit 1; }
safe_kill() { [[ -n "${1:-}" ]] && kill "$1" 2>/dev/null || true; }
cleanup() { safe_kill "$PICKER_PID"; }
trap cleanup EXIT INT TERM

check_deps() {
  local missing_dependencies=()
  for dep in "${DEPS[@]}"; do command -v "$dep" >/dev/null 2>&1 || missing_dependencies+=("$dep"); done
  if (( ${#missing_dependencies[@]} > 0 )); then
    die "Missing dependencies: ${missing_dependencies[*]}"
  fi
}

check_deps

OCR_LANGUAGE_LIST="$(pacman -Qq | grep -iE "tesseract-(ocr|data|langpack)*-" | awk -F '-' '{print $NF}')"

argc() { echo $#; }
rofi_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-ocr-lang.rasi -i -no-show-icons -l 3 -width 30 -p "Select the OCR language"
}

if [ "$(argc $OCR_LANGUAGE_LIST)" -gt 1 ]; then
    OCR_LANGUAGE=$(echo -e "$OCR_LANGUAGE_LIST" | rofi_cmd)
    sleep 0.5 || true
fi

if [ -z "$OCR_LANGUAGE" ]; then
    OCR_LANGUAGE="eng"
fi

hyprpicker -r -z &
PICKER_PID=$!
sleep 0.1 || true

REGION=$(timeout "$SLURP_TIMEOUT" slurp -b "#00000080" -c "#888888ff" -w 1) || die "No region selected (timeout or cancelled)"
[[ -z "$REGION" ]] && die "No region selected"
cleanup

grim -g "$REGION" - \
  | magick - -colorspace Gray -normalize -contrast-stretch 2% -sharpen 0x1.0 -resize 200% png:- \
  | tesseract - stdout -l $OCR_LANGUAGE --psm 6 \
  | wl-copy \
  || die "Failed to capture or process text"
