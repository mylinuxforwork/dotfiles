#!/bin/bash

# ==============================================================================
# Script Name: ml4w-install-sddm.sh
# Description: Installs and manages SDDM for ML4W OS Setup using Gum UI.
# Detection:   Based on package manager (pacman, dnf, zypper)
# ==============================================================================

# --- 1. PRE-FLIGHT CHECKS ---

if ! command -v gum &> /dev/null; then
    echo "Error: 'gum' is not installed. Please install gum first."
    exit 1
fi

# Define Colors for Gum
GUM_CONFIRM_FOREGROUND="#FFFFFF"
GUM_CONFIRM_BACKGROUND="#5A56E0"

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
    gum style --foreground "#FF0000" --border double --align center --width 50 "ERROR: Unsupported Package Manager" "Could not find pacman, dnf, or zypper."
    exit 1
fi

# --- 3. HELPER FUNCTIONS ---

check_sddm_installed() {
    $CHECK_PKG_CMD &> /dev/null
}

check_sddm_active() {
    systemctl is-active --quiet sddm
}

install_sddm() {
    gum spin --spinner dot --title "Installing SDDM on $DISTRO..." -- bash -c "$INSTALL_CMD"
}

disable_other_dms() {
    for dm in $CONFLICTING_DMS; do
        # Check if service exists and is active
        if systemctl is-active --quiet "$dm"; then
            gum spin --spinner dot --title "Disabling conflicting DM: $dm..." -- sudo systemctl stop "$dm"
            sudo systemctl disable "$dm" &> /dev/null
        fi
        # Also check if it is enabled even if not currently active (to be safe)
        if systemctl is-enabled --quiet "$dm" 2>/dev/null; then
             sudo systemctl disable "$dm" &> /dev/null
        fi
    done
}

activate_sddm() {
    # 1. Disable other DMs first
    disable_other_dms
    
    # 2. Enable SDDM (Force overwrites the display-manager.service symlink)
    gum spin --spinner dot --title "Activating SDDM Service..." -- sudo systemctl enable --force --now sddm
}

deactivate_sddm() {
    gum spin --spinner dot --title "Deactivating SDDM..." -- sudo systemctl disable --now sddm
    gum style --foreground "#FFFF00" "SDDM has been deactivated. You are currently without an active Display Manager."
}

install_theme() {
    gum style --foreground "#00FF00" --border double --align center --width 50 "SPECIAL THEME INSTALLATION"
    echo "Starting installation of the ML4W SDDM theme..."
    
    # ==========================================================================
    # TODO: PUT YOUR THEME INSTALLATION LOGIC HERE
    # ==========================================================================
    
    sleep 2 # Simulating work
    gum style --foreground "#00FF00" "Theme installation logic goes here."
}

# --- 4. MAIN LOGIC ---

clear
gum style --foreground "#5A56E0" --border double --align center --width 50 "ML4W SDDM Manager" "Detected System: $DISTRO"

# STATE 1: SDDM Not Installed
if ! check_sddm_installed; then
    gum style --foreground "#FFCC00" "Status: SDDM is NOT installed."
    
    if gum confirm "Do you want to install SDDM?" --selected.background "$GUM_CONFIRM_BACKGROUND" --selected.foreground "$GUM_CONFIRM_FOREGROUND"; then
        install_sddm
        
        if check_sddm_installed; then
            gum style --foreground "#00FF00" "SDDM installed successfully!"
            
            if gum confirm "Do you want to activate SDDM now?" --selected.background "$GUM_CONFIRM_BACKGROUND" --selected.foreground "$GUM_CONFIRM_FOREGROUND"; then
                activate_sddm
                gum style --foreground "#00FF00" "SDDM Activated."
            fi
            
            if gum confirm "Install the special ML4W SDDM Theme?" --selected.background "$GUM_CONFIRM_BACKGROUND" --selected.foreground "$GUM_CONFIRM_FOREGROUND"; then
                install_theme
            fi
        else
            gum style --foreground "#FF0000" "Installation failed."
            exit 1
        fi
    else
        echo "Installation cancelled."
        exit 0
    fi

# STATE 2: Installed but Not Active
elif ! check_sddm_active; then
    gum style --foreground "#FFFF00" "Status: SDDM is installed but NOT active."
    
    if gum confirm "Do you want to activate SDDM?" --selected.background "$GUM_CONFIRM_BACKGROUND" --selected.foreground "$GUM_CONFIRM_FOREGROUND"; then
        activate_sddm
        gum style --foreground "#00FF00" "SDDM Activated."
    fi
    
    if gum confirm "Install the special ML4W SDDM Theme?" --selected.background "$GUM_CONFIRM_BACKGROUND" --selected.foreground "$GUM_CONFIRM_FOREGROUND"; then
        install_theme
    fi

# STATE 3: Installed and Active
else
    gum style --foreground "#00FF00" "Status: SDDM is installed and active."
    echo "Please choose an action:"
    
    # Using gum choose for multiple options in this state
    ACTION=$(gum choose "Install ML4W Theme" "Deactivate SDDM" "Exit" --selected.foreground "$GUM_CONFIRM_FOREGROUND" --cursor.foreground "$GUM_CONFIRM_BACKGROUND")
    
    case $ACTION in
        "Install ML4W Theme")
            install_theme
            ;;
        "Deactivate SDDM")
            if gum confirm "Are you sure you want to deactivate SDDM?" --selected.background "#FF0000" --selected.foreground "#FFFFFF"; then
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
gum style --border normal --align center --width 50 "Done. Have a nice day!"