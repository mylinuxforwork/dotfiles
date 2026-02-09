# Installation

## Test and Install (BETA) with the ML4W OS Live ISO

You can test the ML4W OS without risk with the ML4W OS Live ISO.

<a href="https://ml4w.com/iso/ml4w-os/ml4w-os-2.10.1-x86_64.iso">Download ML4W OS Live ISO</a>

> [!IMPORTANT]
> The ML4W OS will be started automatically with the user 'liveuser' and password 'liveuser'.

### Real Hardware

If you want to try ML4W OS on a real hardware, please prepare a bootable USB Stick (e.g. with Balena Etcher or Rufus on Windows).

Insert the USB Stick and select it from your BIOS Boot Manager. The system will boot up directly into ML4W OS.

### Virtual Machine (KVM/Qemu)

Create a Virtual Machine in Virt Manager, select the stick, set the possible RAM and CPUs and select min. 10 GB harddisc.

Select UEFI and enable 3D acceleration.

Click on Begin Installation to boot up the System into ML4W OS.

> [!IMPORTANT]
> You can change the screen resolution from the Welcome App: Settings/Monitors. Then Logout from the Power Button in the status bar and login again with liveuser (no password).

### Install the Live ISO (BETA)

You can install the Live ISO to your hard drive by opening a terminal and enter:

`sudo install-ml4w-os`

> [!IMPORTANT]
> Enter password 'liveuser'.

Please select your hard drive (all data will be erased!) and follow the instructions. The system will format your hard drive with btrfs and will create standard subvolumes compatible for snapshots with snapper or timeshift.

Please wait until the installation is done and reboot your system.

## Installation with the Dotfiles Installer

::: warning BEFORE YOU START
Please back up your existing `~/.config` folder with your dotfiles before starting the scripts for initial installation.
:::

You can install the ML4W OS Hyprland on any distribution by using the Dotfiles Installer from Flathub. Click on the badge below to install the app:

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

::: warning BEFORE YOU START
The Dotfiles Installer will create a backup from configurations of your `.config` folder that will be overwritten from the installation procedure and previous ML4W OS installations.

If possible, please create a snapshot of your current system if snapper or Timeshift is installed and available.
:::

Copy the following url into the Dotfiles Installer.

#### Stable Release

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst
```
#### Rolling Release

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```

Setup scripts to install the required dependencies are included for Arch Linux (recommended), Fedora and openSuse Tumbleweed.

> [!IMPORTANT]
> From Hyprland Wiki: We officially run and test Hyprland on Arch and NixOS, and we guarantee Hyprland will work there. For any other distro (not based on Arch/Nix) you might have varying amounts of success. However, since Hyprland is extremely bleeding-edge, point release distros like Pop!_OS, Fedora, Ubuntu, etc. will have major issues running Hyprland. Rolling release distros like openSUSE, Solus ,etc. will likely be fine.

The installation of dependencies can take between 5 to 15 minutes depending on your internet connection and system performance.

::: info UNSUPPORTED DISTROS
For other distros, please install <a href="/dotfiles/getting-started/dependencies">the dependencies</a> first. Then install the Dotfiles by skipping the setup script.
:::

The Dotfiles will be installed into the folder `~/.mydotfiles` with symbolic links into `~/.config`.

::: info RECOMMENDATION
I recommend to install a base Hyprland system before installing the ML4W Hyprland Dotfiles. Then you have a stable starting point and can test Hyprland on your system before. Hyprland is complex, under ongoing development and requires additional components. 

On Arch Linux you can also install the Hyprland Desktop Profile first.

You can find the Hyprland Installation instructions on [hyprland wiki](https://wiki.hyprland.org/Getting-Started/Installation/)
:::

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

## Installation with GNU stow

The installation without the Dotfiles Installer is possible but not recommended (especially not for beginners). 

> [!NOTE]
> Please create a backup from your current configuration. This guide is under developement

The manual installation requires stow. Please install it on your system e.g., on Arch with

```sh 
sudo pacman -S stow
```

Please follow the following steps:

```sh 
mkdir -p ~/Projects # Create a projects folder 
cd ~/Projects #cd into the Projects directory
git clone --depth 1 https://github.com/mylinuxforwork/dotfiles # Rolling Release
cd ~/Projects/dotfiles/setup # cd into the setup folder
./setup.sh # Run the setup script to install the dependencies
```
Create symlinks into your home folder

```sh 
cd ~/Projects/dotfiles
stow dotfiles
```

Restart your system.

## Installation in a Virtual Machine (KVM)

In virt-manager please make sure that 3D acceleration is enabled in Video Virtio and the Listen type is set to None in Display Spice.

| Keybind | Action |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd> | Open Hyprland Settings |
| *(Inside Settings → Environments)* | Select `kvm.conf` for better VM support |
