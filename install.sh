#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SKIP_DEPS=false
SKIP_PREFLIGHT=false
SKIP_STOW=false
SKIP_POSTFLIGHT=false
DRY_RUN=false
OVERWRITE=false
SKIP_BINARIES=false

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[INSTALL]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

usage() {
  cat <<'EOF'
Usage: bash install.sh [options]

Orchestrates full dotfiles installation: preflight → deps → stow → postflight.

Options:
  --skip-deps       Do not install dependencies
  --skip-preflight  Do not run preflight setup
  --skip-stow       Do not apply stow (only run pre/post scripts)
  --skip-postflight Do not run postflight setup
  --dry-run         Show what would be done without changing files
  --overwrite       Backup and overwrite existing files in $HOME
  --skip-binaries   Do not copy bundled binaries
  -h, --help        Show this help

Examples:
  bash install.sh --dry-run
  bash install.sh --overwrite
  bash install.sh --skip-preflight --overwrite
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-deps) SKIP_DEPS=true ;;
    --skip-preflight) SKIP_PREFLIGHT=true ;;
    --skip-stow) SKIP_STOW=true ;;
    --skip-postflight) SKIP_POSTFLIGHT=true ;;
    --dry-run) DRY_RUN=true ;;
    --overwrite) OVERWRITE=true ;;
    --skip-binaries) SKIP_BINARIES=true ;;
    -h|--help) usage; exit 0 ;;
    *) error "Unknown option: $1" ;;
  esac
  shift
done

if [[ "$DRY_RUN" == true ]]; then
  info "DRY-RUN mode: no files will be changed"
fi

# Step 1: Run preflight if enabled
if [[ "$SKIP_PREFLIGHT" != true ]]; then
  if [[ -x "$REPO_ROOT/setup/run-preflight.sh" ]]; then
    info "Running preflight setup"
    bash "$REPO_ROOT/setup/run-preflight.sh"
    success "Preflight complete"
  else
    warn "setup/run-preflight.sh not found; skipping"
  fi
else
  info "Skipping preflight"
fi

# Step 2: Install dependencies if enabled
if [[ "$SKIP_DEPS" != true ]]; then
  if [[ -x "$REPO_ROOT/setup/install-deps.sh" ]]; then
    info "Installing dependencies"
    deps_args=()
    [[ "$DRY_RUN" == true ]] && deps_args+=(--dry-run)
    bash "$REPO_ROOT/setup/install-deps.sh" "${deps_args[@]}"
    success "Dependencies installed"
  else
    error "setup/install-deps.sh not found"
  fi
else
  info "Skipping dependency installation"
fi

# Step 3: Apply stow if enabled
if [[ "$SKIP_STOW" != true ]]; then
  if [[ -x "$REPO_ROOT/setup/stow.sh" ]]; then
    info "Applying stow"
    stow_args=()
    [[ "$DRY_RUN" == true ]] && stow_args+=(--dry-run)
    [[ "$OVERWRITE" == true ]] && stow_args+=(--overwrite)
    [[ "$SKIP_BINARIES" == true ]] && stow_args+=(--skip-binaries)
    bash "$REPO_ROOT/setup/stow.sh" "${stow_args[@]}"
    success "Stow complete"
  else
    error "setup/stow.sh not found"
  fi
else
  info "Skipping stow"
fi

# Step 4: Run postflight if enabled
if [[ "$SKIP_POSTFLIGHT" != true ]]; then
  if [[ -x "$REPO_ROOT/setup/run-postflight.sh" ]]; then
    info "Running postflight setup"
    bash "$REPO_ROOT/setup/run-postflight.sh"
    success "Postflight complete"
  else
    warn "setup/run-postflight.sh not found; skipping"
  fi
else
  info "Skipping postflight"
fi

success "Installation complete."

