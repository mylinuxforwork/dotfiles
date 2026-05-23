#!/usr/bin/env bash

set -euo pipefail

# Run the distro-specific preflight script from setup/
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
export repo_path="$REPO_ROOT"

usage(){
  cat <<'EOF'
Usage: bash setup/run-preflight.sh

Detects host distro and runs the matching preflight script in setup/.
The script exports $repo_path so post scripts can source helpers.
EOF
}

if [[ "${1:-}" =~ ^(-h|--help)$ ]]; then
  usage; exit 0
fi

if command -v pacman >/dev/null 2>&1; then
  script="$REPO_ROOT/setup/preflight-arch.sh"
elif command -v dnf >/dev/null 2>&1; then
  script="$REPO_ROOT/setup/preflight-fedora.sh"
elif command -v zypper >/dev/null 2>&1; then
  script="$REPO_ROOT/setup/preflight-opensuse.sh"
else
  echo "No supported preflight for this distribution (no pacman/dnf/zypper found)."
  exit 1
fi

if [[ ! -f "$script" ]]; then
  echo "Preflight script not found: $script"; exit 1
fi

echo "Running preflight: $script"
bash "$script"

echo "Preflight completed."

