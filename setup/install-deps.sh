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
  else
    echo unknown
  fi
}

PM=$(detect_pm)
case "$PM" in
  pacman) distro_packages="$DEPS_DIR/packages-arch" ;;
  dnf) distro_packages="$DEPS_DIR/packages-fedora" ;;
  zypper) distro_packages="$DEPS_DIR/packages-opensuse" ;;
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

if [[ "$PM" == pacman ]]; then
  # Ensure base build tools for AUR helpers
  if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY-RUN] Would ensure base-devel and git are installed via pacman"
  else
    sudo pacman -S --needed --noconfirm base-devel git || true
  fi

  # Detect or install an AUR helper (prefer paru)
  AUR_HELPER=""
  if command -v paru >/dev/null 2>&1; then
    AUR_HELPER=paru
  elif command -v yay >/dev/null 2>&1; then
    AUR_HELPER=yay
  else
    # Try to install paru non-interactively
    if [[ "$DRY_RUN" == true ]]; then
      echo "[DRY-RUN] Would install paru from repo"
    else
      pacman -S --needed --noconfirm paru
    fi
  fi

  # Partition packages into repo packages and AUR packages
  repo_pkgs=()
  aur_pkgs=()
  for pkg in "${all_pkgs[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      repo_pkgs+=("$pkg")
    else
      aur_pkgs+=("$pkg")
    fi
  done

  if [[ "$DRY_RUN" == true ]]; then
    if [[ ${#repo_pkgs[@]} -gt 0 ]]; then
      echo "[DRY-RUN] Would install repo packages with pacman: ${repo_pkgs[*]}"
    fi
    if [[ ${#aur_pkgs[@]} -gt 0 ]]; then
      if [[ -n "$AUR_HELPER" ]]; then
        echo "[DRY-RUN] Would install AUR packages with $AUR_HELPER: ${aur_pkgs[*]}"
      else
        echo "[DRY-RUN] Would install AUR helper (paru) then AUR packages: ${aur_pkgs[*]}"
      fi
    fi
  else
    if [[ ${#repo_pkgs[@]} -gt 0 ]]; then
      sudo pacman -S --needed --noconfirm "${repo_pkgs[@]}"
    fi
    if [[ ${#aur_pkgs[@]} -gt 0 ]]; then
      if [[ -n "$AUR_HELPER" ]]; then
        $AUR_HELPER -S --needed --noconfirm "${aur_pkgs[@]}"
      else
        echo "No AUR helper available to install: ${aur_pkgs[*]}"
        echo "Install paru or yay and re-run"
        exit 1
      fi
    fi
  fi

elif [[ "$PM" == dnf ]]; then
  if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY-RUN] Would run: sudo dnf install -y ${all_pkgs[*]}"
  else
    sudo dnf install -y "${all_pkgs[@]}"
  fi

elif [[ "$PM" == zypper ]]; then
  if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY-RUN] Would run: sudo zypper install -y ${all_pkgs[*]}"
  else
    sudo zypper install -y "${all_pkgs[@]}"
  fi

else
  echo "Unsupported package manager: $PM"; exit 1
fi

echo "Dependency install complete."