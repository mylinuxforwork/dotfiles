#!/bin/bash

cat <<"EOF"
 _   _       _     _ _         ____       _                    
| \ | |_   _(_) __| (_) __ _  |  _ \ _ __(_)_   _____ _ __ ___ 
|  \| \ \ / / |/ _` | |/ _` | | | | | '__| \ \ / / _ \ '__/ __|
| |\  |\ V /| | (_| | | (_| | | |_| | |  | |\ V /  __/ |  \__ \
|_| \_| \_/ |_|\__,_|_|\__,_| |____/|_|  |_| \_/ \___|_|  |___/
                                                               

EOF

nvidia_pkg=(
  nvidia-dkms
  nvidia-settings
  nvidia-utils
  libva
  libva-nvidia-driver-git
)

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo -e "${RED}Failed to change directory to $PARENT_DIR${NONE}"; exit 1; }

# Check and remove other Hyprland packages
echo -e "${YELLOW}Checking for other Hyprland packages and removing if any...${NONE}"
if pacman -Qs hyprland > /dev/null; then
  echo -e "${YELLOW}Hyprland detected. Uninstalling to install Hyprland from the official repo...${NONE}"
  for hyprnvi in hyprland-git hyprland-nvidia hyprland-nvidia-git hyprland-nvidia-hidpi-git; do
    sudo pacman -R --noconfirm "$hyprnvi" 2>/dev/null || true
  done
fi

# Install additional Nvidia packages
echo -e "${YELLOW}Installing additional Nvidia packages...${NONE}"
for krnl in $(cat /usr/lib/modules/*/pkgbase); do
  for NVIDIA in "${krnl}-headers" "${nvidia_pkg[@]}"; do
    echo -e "${BLUE}Installing $NVIDIA...${NONE}"
    sudo pacman -S --noconfirm "$NVIDIA"
  done
done

# Update mkinitcpio configuration for Nvidia modules
if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
  echo -e "${GREEN}Nvidia modules already included in /etc/mkinitcpio.conf${NONE}"
else
  echo -e "${YELLOW}Adding Nvidia modules to /etc/mkinitcpio.conf...${NONE}"
  sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  echo -e "${GREEN}Nvidia modules added to /etc/mkinitcpio.conf${NONE}"
fi

# Rebuild initramfs
echo -e "${YELLOW}Rebuilding initramfs...${NONE}"
sudo mkinitcpio -P

# Configure modprobe for Nvidia
NVEA="/etc/modprobe.d/nvidia.conf"
if [ -f "$NVEA" ]; then
  echo -e "${GREEN}nvidia-drm modeset=1 already added to $NVEA${NONE}"
else
  echo -e "${YELLOW}Adding nvidia-drm modeset=1 to $NVEA...${NONE}"
  echo "options nvidia_drm modeset=1 fbdev=1" | sudo tee -a "$NVEA"
  echo -e "${GREEN}nvidia-drm modeset=1 added to $NVEA${NONE}"
fi

# Configure GRUB for Nvidia
if [ -f /etc/default/grub ]; then
  if ! sudo grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
    echo -e "${YELLOW}Adding nvidia-drm.modeset=1 to GRUB configuration...${NONE}"
    sudo sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia-drm.modeset=1"/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    echo -e "${GREEN}nvidia-drm.modeset=1 added to GRUB configuration${NONE}"
  else
    echo -e "${GREEN}nvidia-drm.modeset=1 is already present in GRUB configuration${NONE}"
  fi
else
  echo -e "${RED}/etc/default/grub does not exist${NONE}"
fi

# Blacklist nouveau
if [[ -z $blacklist_nouveau ]]; then
  read -n1 -rep "${YELLOW}Would you like to blacklist nouveau? (y/n)${NONE} " blacklist_nouveau
  echo
fi

if [[ $blacklist_nouveau =~ ^[Yy]$ ]]; then
  NOUVEAU="/etc/modprobe.d/nouveau.conf"
  if [ -f "$NOUVEAU" ]; then
    echo -e "${GREEN}Nouveau is already blacklisted${NONE}"
  else
    echo -e "${YELLOW}Blacklisting nouveau...${NONE}"
    echo "blacklist nouveau" | sudo tee -a "$NOUVEAU"
    echo -e "${GREEN}Nouveau has been blacklisted${NONE}"
    echo "install nouveau /bin/true" | sudo tee -a "/etc/modprobe.d/blacklist.conf"
  fi
else
  echo -e "${BLUE}Skipping nouveau blacklisting${NONE}"
fi

echo -e "${GREEN}Nvidia setup is complete!${NONE}"
