# Installation

::: warning BEFORE YOU START
Please back up your existing `~/.config` folder with your dotfiles before starting the scripts for initial installation.
:::

The installation script will create a backups from configurations of your .config folder that will be overwritten from the installation procedure and previous ML4W Dotfiles installation.

If possible, please create a snapshot of your current system if snapper or Timeshift is installed and available.

You can decide between the following packages:
- ML4W Dotfiles Main Release (latest tagged release)
- ML4W Dotfiles Rolling Release (main branch including the latest commits)

<iframe width="100%" height="400" src="https://www.youtube.com/embed/siy2vL94yd0" 
title="ML4W Hyprland Installation" frameborder="0" 
allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
allowfullscreen></iframe>

## Recommendation

I recommend to install a base Hyprland system before installing the ML4W Hyprland Dotfiles. Then you have a stable starting point and can test Hyprland on your system before. Hyprland is complex, under ongoing development and requires additional components. 

On Arch Linux you can also install the Hyprland Desktop Profile first.

You can find the Hyprland Installation instructions on [hyprland wiki](https://wiki.hyprland.org/Getting-Started/Installation/)

## Distro (based)

Just copy the following command into your terminal and execute:

::: code-group

```sh [<i class="devicon-archlinux-plain"></i> Arch]
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh)"
```

```sh [<i class="devicon-fedora-plain"></i> Fedora]
bash -c "$(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-fedora.sh)"
```

:::

::: warning AUR not supported anymore
Please note that the AUR packages for the ML4W Dotfiles for Hyprland are not supported anymore. Please uninstall the package with 

```sh 
yay -R ml4w-dotfiles # Main Release
yay -R ml4w-dotfiles-git # Wolling Release
```

:::

::: info Installation folder
The script will ask for an installation folder. Please enter a folder name without spaces. The script will create the folder for you and continue with the installation.

You can also install multiple versions of the ML4W Dotfiles in parallel in different folders. You can switch between the folders with the included activation script (only works with 2.9.5 or higher). 
:::


## Installation with the Dotfiles Installer (Beta)

You can install the ML4W Dotfiles for Hyprland on any distribution by using the Dotfiles Installer.

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

The setup scripts included for Arch, Fedora and openSuse Tumbleweed. For other distros, please install <a href="/dotfiles/getting-started/dependencies">the dependencies</a> first.

Copy the folling url to the Dotfiles Installer:

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```
The Dotfiles will be installed into the folder `~/.mydotfiles` with symbolic links into `~/.config`.

### Minimal Arch Linux

Install the following dependencies on a minimal Arch Linux installation

```sh [<i class="devicon-archlinux-plain"></i> Arch]
sudo pacman -S hyprland vim git wget curl kitty wofi firefox flatpak

```
Reboot and then start Hyprland with 

```sh [<i class="devicon-archlinux-plain"></i> Arch]
Hyprland

```

## Installation with GIT (Rolling Release)

You can install the dotfiles by cloning the latest version (rolling release):

```sh
# 1.) Change into your Downloads folder (create the folder if not available)
cd ~/Downloads

# 2.) Clone the dotfiles repository into the Downloads folder
git clone --depth=1 https://github.com/mylinuxforwork/dotfiles.git

# 3.) Change into the dotfiles/bin folder
cd dotfiles/bin

# 4.) Start the installation
./ml4w-hyprland-setup
```

> [!NOTE]
> Not all features will work, when you install the dotfiles from GIT.

## Install in a Virtual Machine (KVM)

In virt-manager please make sure that 3D acceleration is enabled in Video Virtio and the Listen type is set to None in Display Spice.

| Keybind | Action |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd> | Open Hyprland Settings |
| *(Inside Settings → Environments)* | Select `kvm.conf` for better VM support |