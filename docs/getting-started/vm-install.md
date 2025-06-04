In virt-manager please make sure that 3D acceleration is enabled in Video Virtio and the Listen type is set to None in Display Spice.

### 🖱️ VM Mouse & Display Support (Hyprland Guest)

| Keybind | Action |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd> | Open Hyprland Settings |
| *(Inside Settings → Environments)* | Select `kvm.conf` for better VM support |

---

### 💻 When ML4W Dotfiles is the Host

| Keybind | Action |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>P</kbd> | Pass the SUPER key to the virtual machine |
## Troubleshooting for Hyprland 0.45.2

The current version 0.45.2 isn't working in a Virtual Machine (See https://github.com/hyprwm/aquamarine/issues/109)

You have to downgrade to an older version 0.45.0.

You can do this with the package downgrade

```sh
yay -S downgrade
```

Then downgrade the packages:

```sh
sudo downgrade aquamarine
# Select: aquamarine 0.4.5-1
```

```sh
sudo downgrade hyprland 
# Select: hyprland 0.45.0-1
```

After downgrading, add both packages to IgnorePkg in your pacman.conf to prevent automatic updates.

Then start the installation of the Dotfiles with:

```sh
yay -S ml4w-hyprland
```
