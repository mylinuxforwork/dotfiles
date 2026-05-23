#!/usr/bin/env bash

set -euo pipefail

# Run the distro-specific postflight script from setup/
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
export repo_path="$REPO_ROOT"

usage(){
  cat <<'EOF'
Usage: bash setup/run-postflight.sh

Detects host distro and runs the matching postflight script in setup/. Exports
$repo_path to the child script so helper scripts can be sourced.
EOF
}

if [[ "${1:-}" =~ ^(-h|--help)$ ]]; then
  usage; exit 0
fi

if command -v pacman >/dev/null 2>&1; then
  script="$REPO_ROOT/setup/post-arch.sh"
elif command -v dnf >/dev/null 2>&1; then
  script="$REPO_ROOT/setup/post-fedora.sh"
elif command -v zypper >/dev/null 2>&1; then
  script="$REPO_ROOT/setup/post-opensuse.sh"
else
  echo "No supported postflight for this distribution (no pacman/dnf/zypper found)."
  exit 1
fi

if [[ ! -f "$script" ]]; then
  echo "Postflight script not found: $script"; exit 1
fi

echo "Running postflight: $script"
bash "$script"

echo "Postflight completed."

