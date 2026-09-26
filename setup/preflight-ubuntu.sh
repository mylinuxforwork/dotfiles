#!/usr/bin/env bash

set -e

# Noisy command output (apt-get, cargo, cmake/ninja, go build, etc.) goes
# here instead of the terminal. `gum spin` shows a spinner and only
# prints a wrapped command's output if it fails. Defined here rather
# than in a top-level install script -- this is the first of the two
# Ubuntu scripts to run, and post-ubuntu.sh depends on both existing.
LOG_FILE="$HOME/.ml4w-install.log"
: > "$LOG_FILE"
export LOG_FILE

run_quiet() {
    local title=$1; shift
    echo "=== $title ===" >> "$LOG_FILE"
    # Always tee into LOG_FILE, not just show-on-failure -- gum's own
    # --show-error only prints to the terminal for a failed step and
    # doesn't persist anything, so a compile failure scrolled past (or a
    # step that succeeds but is worth checking later) left no record.
    if ! gum spin --title "$title" --show-error -- bash -c '
        set -o pipefail
        "$@" 2>&1 | tee -a "$LOG_FILE"
    ' _ "$@"; then
        error "$title -- failed (see $LOG_FILE)"
        return 1
    fi
}
export -f run_quiet

# A long install can easily outlast sudo's credential cache (typically
# 15 min), and a password re-prompt inside a `gum spin`-wrapped step would
# be invisible -- indistinguishable from a genuine hang. Keep the sudo
# timestamp alive for as long as this shell (and anything it sources,
# i.e. post-ubuntu.sh too) is running.
sudo -v
( while kill -0 $$ 2>/dev/null; do sudo -n true; sleep 60; done ) &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

# Oh My Posh, pipx, and cargo all install into ~/.local/bin (or expect it
# to already be there) -- on a genuinely fresh account it doesn't exist
# yet. Confirmed live on a clean VM.
mkdir -p "$HOME/.local/bin"

# --------------------------------------------------------------
# Repositories
# --------------------------------------------------------------

# gum isn't installed yet at this point in a fresh run (it's installed at
# the end of this script), so these early repository-setup steps are
# quieted with plain log redirection rather than `gum spin`.
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

# gum (not available in Ubuntu main/universe)
if [ ! -f /etc/apt/keyrings/charm.gpg ]; then
    info "Adding Charm apt repo for gum"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
else
    info "Charm apt repo already present"
fi

# Firefox: plain `apt-get install firefox` on Ubuntu installs a
# transitional snap wrapper, not a native .deb (Ubuntu dropped the deb
# from the archive in 22.04+). Add the Mozilla Team PPA and pin it above
# the snap-transitional package so the shared packages file's `firefox`
# entry resolves to a real .deb, matching what Arch/Fedora/openSUSE get.
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

# gum: only the repo was added above -- install it explicitly now rather
# than leaving it to whatever later step happens to apt-get install it
# first (previously that was the ML4W Settings App's patched bootstrap
# line in post-ubuntu.sh, which meant nothing before that point could
# use `gum spin`/run_quiet for quiet output).
if ! command -v gum &> /dev/null; then
    sudo apt-get install -y gum >> "$LOG_FILE" 2>&1
fi

# --------------------------------------------------------------
# Uninstall swww if exists. To be replaced with awww in the next steps
# --------------------------------------------------------------

if dpkg -l 2>/dev/null | grep -q "^ii  swww "; then
    sudo apt-get remove -y swww >> "$LOG_FILE" 2>&1
fi
