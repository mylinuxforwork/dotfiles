#!/bin/bash
echo -e "${GREEN}"
figlet -f smslant "NVIDIA Setup"
echo -e "${NONE}"

# Prompt user to check for NVIDIA GPU
echo ":: PLEASE NOTE: The installation of NVIDIA drivers is currently BETA."
echo ":: Please report your issues on GitHub."
echo
nvidia=$(gum confirm "Do you have an NVIDIA GPU and like to install the proprietary driver for it?" && echo "Y" || echo "N")

# NVIDIA Setup if Enabled
if [[ $nvidia =~ ^[Yy]$ ]]; then
  echo "Checking for existing Hyprland packages..."
  if $aur_helper -Qs hyprland > /dev/null; then
    echo "Uninstalling old Hyprland packages..."
    for pkg in hyprland-git hyprland-nvidia hyprland-nvidia-git hyprland-nvidia-hidpi-git; do
      $aur_helper -R --noconfirm "$pkg" 2>/dev/null || true
    done
  fi

  echo "Installing NVIDIA packages..."
  nvidia_pkgs=(
    nvidia-dkms nvidia-settings nvidia-utils
    libva libva-nvidia-driver-git
  )
  for krnl in $(cat /usr/lib/modules/*/pkgbase); do
    for pkg in "${krnl}-headers" "${nvidia_pkgs[@]}"; do
      $aur_helper -S --noconfirm --needed "$pkg"
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

  # systemd-boot
  if [ -f /boot/loader/loader.conf ]; then
    # systemd-boot is detected, proceed with the operation
    if [ $(ls -l /boot/loader/entries/*.conf.t2.bkp 2>/dev/null | wc -l) -ne $(ls -l /boot/loader/entries/*.conf 2>/dev/null | wc -l) ]; then
      find /boot/loader/entries/ -type f -name "*.conf" | while read imgconf; do
        sudo cp ${imgconf} ${imgconf}.t2.bkp
        sdopt=$(grep -w "^options" ${imgconf} | sed 's/\b quiet\b//g' | sed 's/\b splash\b//g' | sed 's/\b nvidia-drm.modeset=.\b//g' | sed 's/\b nvidia_drm.fbdev=.\b//g')
        sudo sed -i "/^options/c${sdopt} quiet splash nvidia-drm.modeset=1 nvidia_drm.fbdev=1" ${imgconf}
      done
    else
      echo "systemd-boot is already configured..."
    fi
  fi

  if gum confirm "Would you like to blacklist the Nouveau driver?"; then
    echo "blacklist nouveau" | sudo tee /etc/modprobe.d/nouveau.conf
    echo "install nouveau /bin/true" | sudo tee /etc/modprobe.d/blacklist.conf
  fi

  echo "Configuration complete!"

else
  _writeSkipped
fi
