#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PACKAGE_NAME="dotfiles"
TARGET_HOME="$HOME"
INSTALL_DEPS=false
DRY_RUN=false
OVERWRITE=false
INSTALL_BINARIES=true
RUN_PREFLIGHT=false
RUN_POSTFLIGHT=false

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[STOW]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

usage() {
  cat <<'EOF'
Usage: bash install-stow.sh [options]

Options:
  --install-deps      Install required tools (stow + basic helpers)
  --dry-run           Show what stow would do without changing files
  --overwrite         If files exist in $HOME, back them up and overwrite
  --skip-binaries     Do not copy bundled binaries from setup/packages/
  --run-preflight    Run setup/run-preflight.sh before stow (if exists)
  --run-postflight   Run setup/run-postflight.sh after stow (if exists)
  -h, --help          Show this help

Examples:
  bash install-stow.sh --install-deps
  bash install-stow.sh --dry-run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-deps) INSTALL_DEPS=true ;;
    --dry-run) DRY_RUN=true ;;
    --overwrite) OVERWRITE=true ;;
    --skip-binaries) INSTALL_BINARIES=false ;;
    --run-preflight) RUN_PREFLIGHT=true ;;
    --run-postflight) RUN_POSTFLIGHT=true ;;
    -h|--help) usage; exit 0 ;;
    *) error "Unknown option: $1" ;;
  esac
  shift
done

if [[ ! -d "$REPO_ROOT/$PACKAGE_NAME" ]]; then
  error "Missing package directory: $REPO_ROOT/$PACKAGE_NAME"
fi

install_deps() {
  # Prefer the setup helper when available
  if [[ -x "$REPO_ROOT/setup/install-deps.sh" ]]; then
    info "Using setup/install-deps.sh to install dependencies"
    bash "$REPO_ROOT/setup/install-deps.sh"
    return
  fi

  if command -v pacman >/dev/null 2>&1; then
    info "Installing dependencies with pacman"
    sudo pacman -S --needed --noconfirm stow git curl jq rsync
  elif command -v dnf >/dev/null 2>&1; then
    info "Installing dependencies with dnf"
    sudo dnf install -y stow git curl jq rsync
  elif command -v zypper >/dev/null 2>&1; then
    info "Installing dependencies with zypper"
    sudo zypper install -y stow git curl jq rsync
  else
    error "Unsupported package manager. Install stow manually and rerun."
  fi
}

install_bundled_binaries() {
  local bin_dir="$REPO_ROOT/setup/packages"
  local target_bin="$HOME/.local/bin"

  [[ -d "$bin_dir" ]] || return 0
  mkdir -p "$target_bin"

  for bin in "$bin_dir"/*; do
    if [[ -f "$bin" && -x "$bin" ]]; then
      cp -f "$bin" "$target_bin/"
      info "Installed bundled binary: $(basename "$bin") -> $target_bin"
    fi
  done
}

backup_and_remove_conflicts() {
  local pkg_dir="$REPO_ROOT/$PACKAGE_NAME"
  local backup_root="$HOME/.local/share/${PACKAGE_NAME}-backup-$(date +%s)"

  [[ -d "$pkg_dir" ]] || return 0
  info "Preparing to overwrite existing files — backing up to: $backup_root"

  # When .config already exists as a symlink (common with previous stow runs),
  # remove only the symlink itself so stow can re-create the directory tree
  # without moving the whole project or flattening .config.
  if [[ -L "$TARGET_HOME/.config" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
      info "[DRY-RUN] Would remove existing symlink: $TARGET_HOME/.config"
    else
      rm -f "$TARGET_HOME/.config"
      info "Removed existing symlink: $TARGET_HOME/.config"
    fi
  fi

  # Iterate all files and directories in the package tree
  while IFS= read -r -d '' src; do
    rel_path="${src#$pkg_dir/}"
    target="$TARGET_HOME/$rel_path"
    if [[ -e "$target" || -L "$target" ]]; then
      if [[ "$DRY_RUN" == true ]]; then
        info "[DRY-RUN] Would move existing: $target -> $backup_root/$rel_path"
      else
        mkdir -p "$(dirname "$backup_root/$rel_path")"
        mv -f "$target" "$backup_root/$rel_path"
        info "Moved existing: $target -> $backup_root/$rel_path"
      fi
    fi
  done < <(find "$pkg_dir" -mindepth 1 -print0)

  if [[ "$DRY_RUN" != true ]]; then
    info "Backup complete. Proceeding will allow stow to create new symlinks."
  fi
}

if [[ "$INSTALL_DEPS" == true ]]; then
  install_deps
fi

if [[ "$RUN_PREFLIGHT" == true ]]; then
  if [[ -x "$REPO_ROOT/setup/run-preflight.sh" ]]; then
    info "Running preflight"
    bash "$REPO_ROOT/setup/run-preflight.sh"
  else
    warn "No setup/run-preflight.sh present; skipping preflight"
  fi
fi

command -v stow >/dev/null 2>&1 || error "stow is not installed. Run with --install-deps."

STOW_ARGS=(--dir "$REPO_ROOT" --target "$TARGET_HOME" --no-folding --restow "$PACKAGE_NAME")
if [[ "$DRY_RUN" == true ]]; then
  STOW_ARGS=(-n -v "${STOW_ARGS[@]}")
fi

if [[ "$OVERWRITE" == true ]]; then
  backup_and_remove_conflicts
fi

info "Applying stow package '$PACKAGE_NAME' to $TARGET_HOME"
stow "${STOW_ARGS[@]}"

if [[ "$INSTALL_BINARIES" == true ]]; then
  install_bundled_binaries
fi

if [[ "$RUN_POSTFLIGHT" == true ]]; then
  if [[ -x "$REPO_ROOT/setup/run-postflight.sh" ]]; then
    info "Running postflight"
    bash "$REPO_ROOT/setup/run-postflight.sh"
  else
    warn "No setup/run-postflight.sh present; skipping postflight"
  fi
fi

success "Done. Dotfiles are now managed by GNU Stow."
