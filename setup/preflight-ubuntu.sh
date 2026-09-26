#!/usr/bin/env bash

set -euo pipefail

# Noisy build/apt output goes here instead of the terminal; gum spin
# only shows it on failure. Defined here since this runs first and
# post-ubuntu.sh depends on it existing.
LOG_FILE="$HOME/.ml4w-install.log"
: > "$LOG_FILE"
export LOG_FILE

run_quiet() {
    local title=$1; shift
    echo "=== $title ===" >> "$LOG_FILE"
    # Tee into LOG_FILE always, not just on failure -- gum's
    # --show-error only prints to the terminal, it persists nothing.
    if ! gum spin --title "$title" --show-error -- bash -c '
        set -o pipefail
        "$@" 2>&1 | tee -a "$LOG_FILE"
    ' _ "$@"; then
        error "$title -- failed (see $LOG_FILE)"
        return 1
    fi
}
export -f run_quiet

# Keeps sudo's credential cache warm for the whole install -- a long
# build can outlast it, and a password re-prompt inside gum spin would
# look like a silent hang.
sudo -v
( while kill -0 $$ 2>/dev/null; do sudo -n true; sleep 60; done ) &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

# Oh My Posh/pipx/cargo all expect ~/.local/bin to exist.
mkdir -p "$HOME/.local/bin"

# --------------------------------------------------------------
# Repositories
# --------------------------------------------------------------

# gum isn't installed yet (installed below), so plain log redirection
# instead of gum spin here.
sudo apt-get install -y software-properties-common >> "$LOG_FILE" 2>&1
sudo add-apt-repository -y universe >> "$LOG_FILE" 2>&1
sudo add-apt-repository -y restricted >> "$LOG_FILE" 2>&1

# Hyprland core (hyprland, hypridle, hyprlock, hyprpicker, hyprsunset,
# hyprpolkitagent, hyprland-guiutils, xdg-desktop-portal-hyprland)
if ! grep -Rq "cppiber.*hyprland" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
    info "Adding PPA: ppa:cppiber/hyprland"
    sudo add-apt-repository -y ppa:cppiber/hyprland >> "$LOG_FILE" 2>&1
else
    info "Hyprland PPA already present"
fi

# cliphist (quickshell is built from source in post-ubuntu.sh instead of
# using this PPA's quickshell-git package, to match the exact commit
# already validated to work)
if ! grep -Rq "avengemedia.*danklinux" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
    info "Adding PPA: ppa:avengemedia/danklinux"
    sudo add-apt-repository -y ppa:avengemedia/danklinux >> "$LOG_FILE" 2>&1
else
    info "danklinux PPA already present"
fi

# gum isn't in Ubuntu main/universe. Checked with -s, not -f: a failed
# curl leaves a 0-byte keyring file that -f would treat as present.
if [ ! -s /etc/apt/keyrings/charm.gpg ]; then
    info "Adding Charm apt repo for gum"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
else
    info "Charm apt repo already present"
fi

# Firefox: apt-get install firefox on Ubuntu 22.04+ installs a snap
# wrapper, not a .deb. Add + pin the Mozilla Team PPA so the packages
# file's `firefox` entry resolves to a real .deb.
if ! grep -Rq "mozillateam.*ppa" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
    info "Adding PPA: ppa:mozillateam/ppa (native Firefox .deb, not the snap)"
    sudo add-apt-repository -y ppa:mozillateam/ppa >> "$LOG_FILE" 2>&1
fi
sudo tee /etc/apt/preferences.d/mozilla-firefox > /dev/null <<-'EOF'
	Package: *
	Pin: release o=LP-PPA-mozillateam
	Pin-Priority: 1001
	EOF
sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox > /dev/null <<-'EOF'
	Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";
	EOF

sudo apt-get update >> "$LOG_FILE" 2>&1

# Install gum explicitly now (repo was added above) -- needed for
# gum spin/run_quiet before anything later would apt-get install it.
if ! command -v gum &> /dev/null; then
    sudo apt-get install -y gum >> "$LOG_FILE" 2>&1
fi

# --------------------------------------------------------------
# Uninstall swww if exists. To be replaced with awww in the next steps
# --------------------------------------------------------------

if dpkg -l 2>/dev/null | grep -q "^ii  swww "; then
    sudo apt-get remove -y swww >> "$LOG_FILE" 2>&1
fi
