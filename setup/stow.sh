#!/usr/bin/env bash
set -euo pipefail

# =========================
# CONFIG
# =========================

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE="dotfiles"
TARGET="$HOME"

STATE_DIR="$HOME/.local/state/stow-orchestrator"
TIMESTAMP="$(date +%s)"
BACKUP_DIR="$STATE_DIR/backup-$TIMESTAMP"

mkdir -p "$STATE_DIR"

# =========================
# FLAGS
# =========================

DRY_RUN=false
OVERWRITE=false
ROLLBACK=false

# =========================
# LOGGING
# =========================

log()  { echo "[stow] $*"; }
warn() { echo "[warn] $*"; }
err()  { echo "[err] $*"; }

# =========================
# ARGS
# =========================

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --overwrite) OVERWRITE=true ;;
    --rollback) ROLLBACK=true ;;
    -h|--help)
      echo "Usage: $0 [--dry-run] [--overwrite] [--rollback]"
      exit 0
      ;;
    *) err "Unknown option: $arg"; exit 1 ;;
  esac
done

# =========================
# PATHS (stow truth set)
# =========================

get_repo_paths() {
    {
      find "$REPO_ROOT/$PACKAGE" -maxdepth 1 -type f -printf "%P\n"
      find "$REPO_ROOT/$PACKAGE" -mindepth 2 -maxdepth 2 -printf "%P\n"
    } | grep -v '^$'
}

# =========================
# COLLISION DETECTION
# =========================

detect_collisions() {
  local count=0

  while IFS= read -r rel; do
    local target="$TARGET/$rel"

    if [[ -e "$target" || -L "$target" ]]; then
      echo "[collision] $target"
      count=$((count+1))
    fi
  done < <(get_repo_paths)

  return $count
}

# =========================
# DRY RUN DIFF
# =========================

show_diff() {
  log "Dry-run diff (repo → $TARGET)"

  while IFS= read -r rel; do
    local src="$REPO_ROOT/$PACKAGE/$rel"
    local dst="$TARGET/$rel"

    if [[ ! -e "$dst" && ! -L "$dst" ]]; then
      echo "[NEW]   $rel"
      continue
    fi

    if [[ -L "$dst" ]]; then
      echo "[LINK]  $rel -> $(readlink "$dst")"
      continue
    fi

    if [[ -f "$dst" && -f "$src" ]]; then
      if cmp -s "$src" "$dst"; then
        echo "[OK]    $rel"
      else
        echo "[DIFF]  $rel"
      fi
    else
      echo "[CONFLICT] $rel"
    fi

  done < <(get_repo_paths)
}

# =========================
# BACKUP (transactional snapshot)
# =========================

backup_dirs() {
  log "Backup directory takeover set"

  while IFS= read -r rel; do
    local target="$TARGET/$rel"

    [[ -e "$target" || -L "$target" ]] || continue

    if [[ "$DRY_RUN" == true ]]; then
      echo "[dry-run backup] $target"
    else
      mkdir -p "$BACKUP_DIR"
      mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
      cp -a "$target" "$BACKUP_DIR/$rel"
    fi

  done < <(get_repo_paths)
}

purge_conflict_dirs() {
  log "Directory takeover purge"

  while IFS= read -r rel; do
    local target="$TARGET/$rel"

    if [[ -e "$target" || -L "$target" ]]; then

      if [[ "$DRY_RUN" == true ]]; then
        echo "[dry-run remove] $target"
      else
        rm -rf "$target"
        log "removed $target"
      fi
    fi

  done < <(get_repo_paths)
}

# =========================
# ROLLBACK
# =========================

rollback() {
  log "Searching latest backup..."

  local latest
  latest=$(ls -1dt "$STATE_DIR"/backup-* 2>/dev/null | head -n 1 || true)

  [[ -d "$latest" ]] || {
    err "No backup found"
    exit 1
  }

  log "Rollback from $latest"

  rsync -a "$latest/" "$TARGET/"

  log "Rollback complete"
}

# =========================
# STOW EXECUTION
# =========================

run_stow() {
  log "Running stow..."

  local args=(-d "$REPO_ROOT" -t "$TARGET" "$PACKAGE")

  if [[ "$DRY_RUN" == true ]]; then
    args=(-n -v "${args[@]}")
  fi

  stow "${args[@]}"
}

# =========================
# MAIN PIPELINE
# =========================

main() {

  if [[ "$ROLLBACK" == true ]]; then
    rollback
    exit 0
  fi

  log "Scanning repository..."

  if detect_collisions; then
    warn "Collisions detected"

    if [[ "$OVERWRITE" != true ]]; then
      err "Use --overwrite to backup + replace"
      exit 1
    fi

    backup_dirs
  fi

  if [[ "$DRY_RUN" == true ]]; then
    show_diff
    exit 0
  fi

  backup_dirs
  purge_conflict_dirs
  run_stow

  log "Done."
}

main