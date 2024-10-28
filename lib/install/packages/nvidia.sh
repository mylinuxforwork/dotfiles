#!/bin/bash

figlet -f smslant "Nvidia Setup"

# Prompt user to check for NVIDIA GPU
nvidia=$(gum confirm "Do you have an NVIDIA GPU and like to install the proprietary driver for it?" && echo "Y" || echo "N")

# NVIDIA Setup if Enabled
if [[ $nvidia =~ ^[Yy]$ ]]; then
  echo "Checking for existing Hyprland packages..."
  if yay -Qs hyprland > /dev/null; then
    echo "Uninstalling old Hyprland packages..."
    for pkg in hyprland-git hyprland-nvidia hyprland-nvidia-git hyprland-nvidia-hidpi-git; do
      yay -R --noconfirm "$pkg" 2>/dev/null || true
    done
  fi

  echo "Installing NVIDIA packages..."
  nvidia_pkgs=(
    nvidia-dkms nvidia-settings nvidia-utils
    libva libva-nvidia-driver-git
  )
  for krnl in $(cat /usr/lib/modules/*/pkgbase); do
    for pkg in "${krnl}-headers" "${nvidia_pkgs[@]}"; do
      yay -S --noconfirm "$pkg"
    done
  done

  if ! grep -qE '^MODULES=.*nvidia.*nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
    sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    echo "Nvidia modules added to /etc/mkinitcpio.conf"
  fi
  sudo mkinitcpio -P

  NVEA="/etc/modprobe.d/nvidia.conf"
  if [[ ! -f "$NVEA" ]]; then
    echo "options nvidia_drm modeset=1 fbdev=1" | sudo tee "$NVEA"
  fi

  if [ -f /etc/default/grub ]; then
    sudo sed -i -e '/GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ nvidia-drm.modeset=1 nvidia_drm.fbdev=1"/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
  fi

  if gum confirm "Would you like to blacklist the Nouveau driver?"; then
    echo "blacklist nouveau" | sudo tee /etc/modprobe.d/nouveau.conf
    echo "install nouveau /bin/true" | sudo tee /etc/modprobe.d/blacklist.conf
  fi
fi

echo "Configuration complete!"
