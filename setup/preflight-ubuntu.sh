#!/usr/bin/env bash

mkdir -p "$HOME/.local/bin"

# --------------------------------------------------------------
# Repositories
# --------------------------------------------------------------

sudo apt-get install -y software-properties-common
sudo add-apt-repository -y universe
sudo add-apt-repository -y restricted

# Hyprland core
if ! grep -Rq "cppiber.*hyprland" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
    info "Adding PPA: ppa:cppiber/hyprland"
    sudo add-apt-repository -y ppa:cppiber/hyprland
else
    info "Hyprland PPA already present"
fi

# cliphist (quickshell itself is built from source in post-ubuntu.sh)
if ! grep -Rq "avengemedia.*danklinux" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
    info "Adding PPA: ppa:avengemedia/danklinux"
    sudo add-apt-repository -y ppa:avengemedia/danklinux
else
    info "danklinux PPA already present"
fi

# gum (not in Ubuntu main/universe). -s, not -f: a failed curl leaves a
# 0-byte keyring that -f would treat as present.
if [ ! -s /etc/apt/keyrings/charm.gpg ]; then
    info "Adding Charm apt repo for gum"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
else
    info "Charm apt repo already present"
fi

# Firefox: apt-get install firefox on 22.04+ installs a snap wrapper,
# not a .deb. Pin the Mozilla Team PPA so packages' `firefox` resolves
# to a real .deb.
if ! grep -Rq "mozillateam.*ppa" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
    info "Adding PPA: ppa:mozillateam/ppa (native Firefox .deb, not the snap)"
    sudo add-apt-repository -y ppa:mozillateam/ppa
fi
sudo tee /etc/apt/preferences.d/mozilla-firefox > /dev/null <<-'EOF'
	Package: *
	Pin: release o=LP-PPA-mozillateam
	Pin-Priority: 1001
	EOF
sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox > /dev/null <<-'EOF'
	Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";
	EOF

sudo apt-get update

if ! command -v gum &> /dev/null; then
    sudo apt-get install -y gum
fi

# --------------------------------------------------------------
# Uninstall swww if exists. To be replaced with awww in the next steps
# --------------------------------------------------------------

if dpkg -l 2>/dev/null | grep -q "^ii  swww "; then
    sudo apt-get remove -y swww
fi
