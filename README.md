# ML4W dotfiles 2.8.1

This is my configuration of Hyprland (Wayland) and Qtile (X11) for Arch Linux based distributions. This package includes an installation script to install and setup the required components.

<a href="https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/screenshots/v281/screenshot-281-1.png?ref_type=heads" target="_blank"><img src="screenshots/v281/screenshot-281-1.png" /></a>

PLEASE NOTE: This branch is the rolling release of the ML4W dotfiles and includes the latest changes. 

Latest official release 2.8.1: <a href="https://youtu.be/KHwJxpV_L1g" target="_blank">Watch on YouTube</a>

You can find the installation video (Version 2.7.1) on YouTube: <a href="https://youtu.be/kHG5czrQ7WA" target="_blank">Install Arch Linux with Hyprland & Qtile</a>

[TOC]

# Installation

To make it easy for you to get started with the ML4W dotfiles, here's a list of recommended next steps.

The package includes an installation script install.sh that will guide you through all steps of the installation or update process.

## Supported platforms

The dotfiles are tested with the following Arch based distributions:

- Arch Linux (recommended)
- Manjaro Linux
- Arco Linux
- EndeavourOS

But the installation should work on all Arch Linux based distributions as well.

For Arco Linux users: Please reinstall/force the installation of all packages during the installation/update process of the install script. The script will also offer to remove ttf-ms-fonts if installed to avoid issues with icons on waybar. 

## Before you start

PLEASE BACKUP YOUR EXISTING .config FOLDER WITH YOUR DOTFILES BEFORE STARTING THE SCRIPTS FOR INITIAL INSTALLTION.
PLEASE READ THIS README until the end before starting the installation.

The installation script will try to create a backup from an previous dotfiles installation.

Please note: To get the default Linux folder structure incl. Downloads, etc please install the packages xdg-user-dirs and run xdg-user-dirs-update.

## Reference Installation

The reference installation on the dotfiles is based on Arch Linux installed with a minimal profile. 

Please watch the video on YouTube: https://youtu.be/kHG5czrQ7WA

## Installation with GIT

```
# 1.) Change into your Downloads folder
cd ~/Downloads

# 2.) Clone the dotfiles repository into the Downloads folder
git clone https://gitlab.com/stephan-raabe/dotfiles.git

# 3.) Change into the dotfiles folder
cd dotfiles

# 4.) Start the installation
./install.sh

```

## Installation with GIT of the rolling release

```
# 1.) Change into your Downloads folder where you have downloaded the release to
cd ~/Downloads

# 2.) Unzip
git clone https://gitlab.com/stephan-raabe/dotfiles.git

# 3.) Change into the new dotfiles folder
cd dotfiles

# 4.) Switch to dev branch
git checkout dev

# 4.) Start the installation to update
./install.sh

```

## Update with GIT

```
# 1.) Change into your Downloads folder
cd ~/Downloads/dotfiles

# Switch to rolling release
# git checkout origin/main

# 2.) Pull the latest version and update the repository
git stash; git pull

# 3.) Start the installation to update
./install.sh

```

You can create a clean reinstallation by removing the folder ~/dotfiles Please note that you can create a backup of your exsiting configuration with the backup feature of the install script. It's recommended to remove the folder ~/dotfiles only after creating a backup. 

## Dotfiles Installer

You can also use the dotfiles installer script to download and install the latest release: https://gitlab.com/stephan-raabe/installer

## Installation Hook

The installation script will prepare the configuration files in a folder ~/dotfiles-versions/[version] before copying into the final destination in ~/dotfiles

If you want to modify the installation files just before the copy procedure starts, you can create a file hook.sh in the folder ~/dotfiles-versions

You can delete folders and files or update existing configurations.

```
#!/bin/bash
rm -rf ~/dotfiles-versions/$version/vim/
rm -rf ~/dotfiles-versions/$version/nvim/
```

This script will for example remove the vim and nvim folder before the installation. The symbolic link will not be created because the source folder doesn't exits.

You can find a template in .install/templates/hook.sh

## Hyprland & NVIDIA 

Users have reported that Hyprland with dotfiles could be installed successfully on setups with NVDIA GPUs using the nouveau open source drivers. 

There is no official Hyprland support for Nvidia hardware. However, you might make it work properly following this page.
https://wiki.hyprland.org/Nvidia/

## Launch Hyprland from tty

The suggested method to start Hyprland is from tty with the command Hyprland bacause login managers (display managers) are not official supported (https://wiki.hyprland.org/Getting-Started/Master-Tutorial/#launching-hyprland)

```
# Start Hyprland
Hyprland
```

You can install a custom tty login issue (layout) with the dotfiles installer.

## Launch Hyprland with a Display Manager

I made good experiences with the Display Manager SDDM (https://github.com/sddm/sddm). Also gdm could work. 

```
yay -S sddm
```

The dotfiles installation script will offer to deactivate the installed display manager and to activate SDDM. 

The dotfiles package also includes a configuration for the SDDM theme sdd-sugar-candy (https://github.com/Kangie/sddm-sugar-candy) and a configuration to run SDDM in X11 mode to get the best compatibility.

With the Hyprland settings script you can copy the current wallpaper into SDDM and use it as a background.

Please check the troubleshooting section in case of issues.

## Installation in a KVM virtual machine

Qtile X11 works fine in a KVM virtual machine. The Hyprland performance is low but it's enough for testing new features.

In virt-manager please make sure that 3D acceleration is enabled in Video Virtio and the Listen type is set to None in Display Spice.

To fix the mouse issue on Hyprland, open the Hyprland settings with <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd> and select in Environments the variation kvm.conf

## Base Hyprland installation with Hyperland Starter

If you want to install only the core packages of Hyprland as a starting point for your Hyprland experiments please also try my Hyprland Starter script: https://gitlab.com/stephan-raabe/hyprland-starter

# Some important key bindings

- <kbd>SUPER</kbd> + <kbd>RETURN</kbd>: Alacritty
- <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>RETURN</kbd>: rofi application launcher
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>W</kbd>: Change wallpaper
- <kbd>SUPER</kbd> + <kbd>PRINT</kbd>: Screenshot
- <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>Q</kbd>: Logout screen
- <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd>: Settings script on Hyprland
- <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>B</kbd>: Reload waybar on Hyprland

All keybindings for Hyprland with right mouse click on Apps in waybar or here: 
https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/hypr/conf/keybindings.conf

All keybindings for Qtile: https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/qtile/config.py

# Hyprland

<a href="https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/screenshots/v28/screenshot-28-1.png?ref_type=heads" target="_blank"><img src="screenshots/v28/screenshot-28-1.png" /></a>

<a href="https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/screenshots/v28/screenshot-28-2.png?ref_type=heads" target="_blank"><img src="screenshots/v28/screenshot-28-2.png" /></a>

<a href="https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/screenshots/v28/screenshot-28-3.png?ref_type=heads" target="_blank"><img src="screenshots/v28/screenshot-28-3.png" /></a>

<b><a href="https://gitlab.com/stephan-raabe/dotfiles/-/tree/main/screenshots?ref_type=heads">You can find more screenshots here.</a></b>

<a href="https://youtu.be/e9ro_P9rbFk" target="_blank">Watch on YouTube</a>

## ML4W Welcome App

After starting the ML4W dotfiles for the first time, the ML4W Welcome App appears. This app is the starting point to discover the Hyprland setup.

<img src="screenshots/screenshot-welcome.app.png" />

The welcome screen includes the most important keybindings to open a terminal or a browser.

You can start the ML4W Welcome App by clicking on the L icon on the right side in waybar or be entering ml4w in your terminal (if you're using the .bashrc from the dotfiles).

In the Settings Menu you can access the following functions:

- Update Wallpaper: Opens the wallpaper selector
- Change Waybar Theme: Opens the waybar theme switcher and gives access to the available themes for the waybar status bar
- Change GTK Theme: Opens nwg-look to select the theme for GTK 3 applications incl. widgets, icons and cursors
- Refresh GTK Settings: Reloads the Hyprland GTK configuration (required when changing the mouse cursor)
- Hyprland Settings: Opens the Hyprland Settings script to customize the look and feel, environment variables, monitor resolution, etc.
- Network Settings: Select your network configuration incl. WiFi
- Update your System: Starts the terminal application to update your Arch packages (pacman & yay)
- Cleanup your System: Removes old orphans and cached files generated during previous installations
- Reload Waybar: Reloads the waybar
- Toggle Waybar: You can hide or show waybar when you want to try our other status bars.

You can find the sourcecode of the ML4W Welcome App in this repository:
https://gitlab.com/stephan-raabe/ml4w-welcome

## Wallpaper and Pywal

Included is a pywal configuration that changes the color scheme based on a randomly selected wallpaper. With the key binding <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>W</kbd> you can change the wallpaper coming from the folder ~/wallpaper/. 

<kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>W</kbd> opens rofi with a list of installed wallpapers in ~/wallpaper/ for your individual selection. 

## Waybar themes and themeswitcher

In addition, you can switch the Waybar Template with <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>T</kbd> or by pressing the "..." icon in Waybar with the themeswitcher. 

The templates are available in ~/dotfiles/waybar/themes. You can add your own personal themes into this folder. 

More information here: https://gitlab.com/stephan-raabe/dotfiles/-/tree/main/waybar

## Hyprland settings

You can open the settings script with <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd> to select variations for your hyprland.conf and customize your desktop even more.

You can create custom variations by copying a file from the ~/dotfiles/hypr/conf subfolders like monitor/default.conf, give the file a custom name (e.g., mymonitor.conf) and select the variation in the settings script in the corresponding section.

You can also edit the file custom.conf which is included at the bottom of the hyprland.conf and can hold you personal configurations.

You can also edit the file directly in the settings script in the section Custom.

## Screensharing and recording

In case you have issues with starting Waybar please make sure that only one xdg-desktop-portal-x is installed additionally to xdg-desktop-portal.

I had several issues with xdg-desktop-portal-wlr on Hyprland and Waybar. Please make sure that xdg-desktop-portal-wlr is uninstalled and xdg-desktop-portal-hyprland is installed.

More information you can find here:
https://gist.github.com/PowerBall253/2dea6ddf6974ba4e5d26c3139ffb7580

Please note that every Arch Linux system is different and I cannot guarantee that everything works fine on your system.

## Main packages

- Terminal: alacritty
- Editor: nvim
- Prompt: starship
- Icons: Font Awesome
- Launch Menus: Rofi
- Colorscheme: pywal
- Browsers: chromium (brave optional)
- Filemanager: Thunar
- Cursor: Bibata Modern Ice
- Icons: Papirus-Icon-Theme
- Status Bar: waybar
- Screenshots: grim & slurp
- Clipboard Manager: cliphist
- Logout: wlogout 
- Idle Manager: hypridle
- Screenlock: hyprlock

# Qtile X11

<a href="https://youtu.be/e9ro_P9rbFk" target="_blank"><img src="screenshots/v27/screenshot-27-3.png" alt="Click to watch on YouTube" /></a>

<a href="https://youtu.be/e9ro_P9rbFk" target="_blank"><img src="screenshots/v27/screenshot-27-4.png" alt="Click to watch on YouTube" /></a>

## Wallpaper and Pywal

Included is a pywal configuration that changes the color scheme based on a randomly selected wallpaper. With the key binding <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>W</kbd> you can change the wallpaper coming from the folder ~/wallpaper/. 

<kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>W</kbd> opens rofi with a list of installed wallpapers in ~/wallpaper/ for your individual selection. 

## Main Packages

- Terminal: alacritty
- Editor: nvim
- Prompt: starship
- Icons: Font Awesome
- Launch Menus: Rofi
- Colorscheme: pywal
- Browsers: chromium (brave optional)
- Filemanager: Thunar
- Cursor: Bibata Modern Ice
- Icons: Papirus-Icon-Theme
- Status Bar: Qtile status bar
- Compositor: picom
- Screenshots: scrot

# Troubleshooting

## Missing icons in waybar

In case of missing icons on waybar, it's due to a conflict between several installed fonts (can happen especially on Arco Linux). Please make sure that ttf-ms-fonts is uninstalled and ttf-font-awesome and otf-font-awesome are installed with

```
yay -R ttf-ms-fonts
yay -S ttf-font-awesome otf-font-awesome
```

## SDDM not showing (only black screen with cursor)

Switch to another tty with <kbd>CTRL</kbd> + <kbd>ALT</kbd> + <kbd>F3</kbd> Now you can login with your user.

Start Hyprland with Hyprland.

You can try to reinstall all sddm related packages.

```
yay -S sddm-git sddm-sugar-candy-git
```

Or you can install another display manager.

To stop, disable and remove sddm service.

```
sudo systemctl stop sddm.service
sudo systemctl disable sddm.service
sudo rm /etc/systemd/system/display-manager.service
```

## Waybar is not loading

There could be a conflict with xdg-desktop-portal-gtk. Please try to remove the package if installed with:

```
sudo pacman -R xdg-desktop-portal-gtk
```

# Wallpaper repository

You can find my wallpaper collection in the repository https://gitlab.com/stephan-raabe/wallpaper

# Special Thanks

THANK YOU very much for all your support, contributions and ideas:

- Diana Ward: https://github.com/dianaw353
- Don Williams: https://github.com/dwilliam62
- Teodor Orzechowski: https://gitlab.com/sq6gtt
- Jamie Deppeler: https://gitlab.com/bknight2k

and many more...

Thanks to all YouTube subscribers for all your great feedback.

# Inspirations

The following projects have inspired me:

- https://github.com/dianaw353/hyprland-configuration-rootfs
- https://github.com/prasanthrangan/hyprdots
- https://github.com/sudo-harun/dotfiles

and many more...
