#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
DEPS_DIR="$REPO_ROOT/setup/dependencies"
DRY_RUN=false

usage(){
  cat <<'EOF'
Usage: bash setup/install-deps.sh [--dry-run]

Installs packages listed in setup/dependencies/*. The script chooses the
appropriate package list for the host (arch/fedora/opensuse) and installs
the base list in `packages` as well.

Options:
  --dry-run   Print package manager command instead of running it
  -h --help   Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
  shift
done

detect_pm() {
  if command -v pacman >/dev/null 2>&1; then
    echo pacman
  elif command -v dnf >/dev/null 2>&1; then
    echo dnf
  elif command -v zypper >/dev/null 2>&1; then
    echo zypper
  elif command -v apt-get >/dev/null 2>&1; then
    echo apt
  else
    echo unknown
  fi
}

PM=$(detect_pm)
case "$PM" in
  pacman) distro_packages="$DEPS_DIR/packages-arch" ;;
  dnf) distro_packages="$DEPS_DIR/packages-fedora" ;;
  zypper) distro_packages="$DEPS_DIR/packages-opensuse" ;;
  apt) distro_packages="$DEPS_DIR/packages" ;;
  *) echo "Unsupported package manager: $PM"; exit 1 ;;
esac

all_pkgs=( )
if [[ -f "$DEPS_DIR/packages" ]]; then
  while IFS= read -r p; do [[ -n "$p" ]] && all_pkgs+=("$p"); done < "$DEPS_DIR/packages"
fi
if [[ -f "$distro_packages" ]]; then
  while IFS= read -r p; do [[ -n "$p" ]] && all_pkgs+=("$p"); done < "$distro_packages"
fi

if [[ ${#all_pkgs[@]} -eq 0 ]]; then
  echo "No packages found to install; check $DEPS_DIR"; exit 0
fi

case "$PM" in
  pacman)
    cmd=(sudo pacman -S --needed --noconfirm "${all_pkgs[@]}")
    ;;
  dnf)
    cmd=(sudo dnf install -y "${all_pkgs[@]}")
    ;;
  zypper)
    cmd=(sudo zypper install -y "${all_pkgs[@]}")
    ;;
  apt)
    # For apt we will run update then install; store only the install command here
    cmd=(sudo apt install -y "${all_pkgs[@]}")
    ;;
esac

if [[ "$DRY_RUN" == true ]]; then
  echo "[DRY-RUN] Would run: ${cmd[*]}"
  exit 0
fi

echo "Installing ${#all_pkgs[@]} packages using $PM"
# run command array; special-case apt with chained commands
if [[ "$PM" == apt ]]; then
  sudo apt-get update
  sudo apt-get install -y "${all_pkgs[@]}"
else
  "${cmd[@]}"
fi

echo "Dependency install complete."

