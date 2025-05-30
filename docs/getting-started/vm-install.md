In virt-manager please make sure that 3D acceleration is enabled in Video Virtio and the Listen type is set to None in Display Spice.

To improve the mouse support on Hyprland in the VM, open the Hyprland settings with <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd> and select in Environments the variation kvm.conf

If you're running the ML4W Dotfiles as a host, you can pass the SUPER key to the VM with <kbd>SUPER</kbd> +  <kbd>P</kbd>

## Troubleshooting for Hyprland 0.45.2

The current version 0.45.2 isn't working in a Virtual Machine (See https://github.com/hyprwm/aquamarine/issues/109)

You have to downgrade to an older version 0.45.0.

You can do this with the package downgrade

`yay -S downgrade`

`sudo downgrade aquamarine` and select **aquamarine 0.4.5-1**

`sudo downgrade hyprland` and select **hyprland 0.45.0-1**

Add both packages to IgnorePkg.

Then start the installation of the Dotfiles with `yay -S ml4w-hyprland`

