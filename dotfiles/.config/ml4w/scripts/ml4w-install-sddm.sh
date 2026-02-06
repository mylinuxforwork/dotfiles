#!/bin/bash

# --- 1. PRE-FLIGHT CHECKS ---

if ! command -v gum &> /dev/null; then
    echo "Error: 'gum' is not installed. Please install gum first."
    exit 1
fi

# List of conflicting Display Managers to check
CONFLICTING_DMS="gdm lightdm lxdm xdm mdm slim wdm"

# --- 2. OS DETECTION (By Package Manager) ---

if command -v pacman &> /dev/null; then
    DISTRO="Arch Linux"
    INSTALL_CMD="sudo pacman -S --noconfirm sddm"
    CHECK_PKG_CMD="pacman -Qi sddm"
elif command -v dnf &> /dev/null; then
    DISTRO="Fedora"
    INSTALL_CMD="sudo dnf install -y sddm"
    CHECK_PKG_CMD="rpm -q sddm"
elif command -v zypper &> /dev/null; then
    DISTRO="openSUSE Tumbleweed"
    INSTALL_CMD="sudo zypper install -y sddm"
    CHECK_PKG_CMD="rpm -q sddm"
else
    echo "ERROR: Unsupported package manager"
    exit 1
fi

primarycolor=$(cat ~/.config/ml4w/colors/primary)
onsurfacecolor=$(cat ~/.config/ml4w/colors/onsurface)
onprimarycolor=$(cat ~/.config/ml4w/colors/onprimary)

# --- 3. HELPER FUNCTIONS ---

check_sddm_installed() {
    $CHECK_PKG_CMD &> /dev/null
}

check_sddm_active() {
    systemctl is-active --quiet sddm
}

install_sddm() {
    # Sudo refresh to ensure password prompt is seen
    sudo -v
    gum spin --spinner dot --title "Installing SDDM on $DISTRO..." -- bash -c "$INSTALL_CMD"
}

disable_other_dms() {
    for dm in $CONFLICTING_DMS; do
        # Only disable the service, DO NOT stop it.
        # Stopping it would kill the current GUI session immediately.
        if systemctl is-enabled --quiet "$dm" 2>/dev/null; then
             gum spin --spinner dot --title "Disabling conflicting DM: $dm..." -- sudo systemctl disable "$dm"
        fi
    done
}

activate_sddm() {
    # 1. Force a sudo refresh so the user can type the password NOW
    if ! sudo -v; then
        echo "ERROR: Authentication failed. Aborting."
        exit 1
    fi

    # 2. Disable other DMs first (only disables auto-start, does not kill current session)
    disable_other_dms
    
    # 3. Enable SDDM (removed --now so it doesn't start immediately)
    if gum spin --spinner dot --title "Enabling SDDM Service..." -- sudo systemctl enable sddm; then
        echo ":: SDDM Service Enabled."
        
        # 4. Notify user that reboot is required
        echo ":: Please reboot your system to apply changes."
    else
        echo "ERROR: Failed to enable SDDM systemd service."
        exit 1
    fi
}

deactivate_sddm() {
    # Sudo refresh
    if ! sudo -v; then exit 1; fi
    gum spin --spinner dot --title "Deactivating SDDM..." -- sudo systemctl disable sddm
    echo ":: SDDM has been deactivated. You are currently without an active Display Manager."
}

install_theme() {
    echo ":: Starting installation of the ML4W SDDM theme..."
    
    # Clone repository
    # Copy repository

    # cd SilentSDDM/
    # sudo mkdir -p /usr/share/sddm/themes/ml4w
    # sudo cp -rf . /usr/share/sddm/themes/ml4w/

    sleep 2 # Simulating work
    echo ":: ML4W SDDM theme installed succesfully"
}

# --- 4. MAIN LOGIC ---

clear
figlet -f smslant "ML4W SDDM"

# STATE 1: SDDM Not Installed
if ! check_sddm_installed; then
    gum style --foreground "#FFCC00" "Status: SDDM is NOT installed."
    
    if gum confirm "Do you want to install SDDM?" --selected.background=$primarycolor --selected.foreground=$onprimarycolor; then
        install_sddm
        
        if check_sddm_installed; then
            echo ":: SDDM installed successfully!"
            
            if gum confirm "Do you want to activate SDDM now?" --selected.background=$primarycolor --selected.foreground=$onprimarycolor; then
                activate_sddm
                echo ":: SDDM Activated."
            fi
            
            if gum confirm "Install the special ML4W SDDM Theme?" --selected.background=$primarycolor --selected.foreground=$onprimarycolor; then
                install_theme
            fi
        else
            echo "ERROR: Installation failed."
            exit 1
        fi
    else
        echo ":: Installation cancelled."
        exit 0
    fi

# STATE 2: Installed but Not Active
elif ! check_sddm_active; then
    echo ":: SDDM is installed but NOT active."
    if gum confirm "Do you want to activate SDDM?" --selected.background=$primarycolor --selected.foreground=$onprimarycolor; then
        activate_sddm
        echo ":: SDDM Activated."
    fi
    
    if gum confirm "Install the special ML4W SDDM Theme?" --selected.background=$primarycolor --selected.foreground=$onprimarycolor; then
        install_theme
    fi

# STATE 3: Installed and Active
else
    echo ":: SDDM is installed and active."
    
    # Using gum choose for multiple options in this state
    ACTION=$(gum choose "Install ML4W Theme" "Deactivate SDDM" "Exit" --selected.background=$primarycolor --selected.foreground=$onprimarycolor)
    
    case $ACTION in
        "Install ML4W Theme")
            install_theme
            ;;
        "Deactivate SDDM")
            if gum confirm "Are you sure you want to deactivate SDDM?" --selected.background=$primarycolor --selected.foreground=$onprimarycolor; then
                deactivate_sddm
            fi
            ;;
        "Exit")
            echo "Exiting."
            exit 0
            ;;
    esac
fi

# Final message
echo ":: Done!"