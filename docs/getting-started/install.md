# Installation

::: warning BEFORE YOU START
Please back up your existing `~/.config` folder with your dotfiles before starting the scripts for initial installation.
:::

The Dotfiles Installer will create a backup from configurations of your `.config` folder that will be overwritten from the installation procedure and previous ML4W Dotfiles installations.

If possible, please create a snapshot of your current system if snapper or Timeshift is installed and available.

## Recommendation

I recommend to install a base Hyprland system before installing the ML4W Hyprland Dotfiles. Then you have a stable starting point and can test Hyprland on your system before. Hyprland is complex, under ongoing development and requires additional components. 

On Arch Linux you can also install the Hyprland Desktop Profile first.

You can find the Hyprland Installation instructions on [hyprland wiki](https://wiki.hyprland.org/Getting-Started/Installation/)

## Installation with the Dotfiles Installer

You can install the ML4W Dotfiles for Hyprland on any distribution by using the Dotfiles Installer from Flathub. Click on the badge below to install the app:

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

Copy the following url into the Dotfiles Installer.

#### Stable Release

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst
```
#### Rolling Release

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```

Setup scripts to install the required dependencies are included for Arch, Fedora and openSuse Tumbleweed. 

> [!NOTE]
> The installation of dependencies can take between 10 to 20 minutes. 

For other distros, please install <a href="/dotfiles/getting-started/dependencies">the dependencies</a> first.

The Dotfiles will be installed into the folder `~/.mydotfiles` with symbolic links into `~/.config`.

### For Minimal Arch Linux installations

Install the following dependencies on a minimal Arch Linux installation

```sh [<i class="devicon-archlinux-plain"></i> Arch]
sudo pacman -S hyprland vim kitty firefox flatpak

```
Reboot and then start Hyprland with 

```sh [<i class="devicon-archlinux-plain"></i> Arch]
Hyprland

```
Open Firefox, open the Dotfiles Installer Homepage and follow the installation instructions.

::: warning AUR not supported anymore
Please note that the AUR packages for the ML4W Dotfiles for Hyprland are not supported anymore. Please uninstall the package with 

```sh 
yay -R ml4w-dotfiles # Main Release
yay -R ml4w-dotfiles-git # Rolling Release
```
:::

## Install in a Virtual Machine (KVM)

In virt-manager please make sure that 3D acceleration is enabled in Video Virtio and the Listen type is set to None in Display Spice.

| Keybind | Action |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd> | Open Hyprland Settings |
| *(Inside Settings → Environments)* | Select `kvm.conf` for better VM support |
