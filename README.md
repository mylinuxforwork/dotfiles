# ML4W dotfiles 2.8.3 RC2

An advanced configuration of Hyprland and Qtile for Arch Linux based distributions. This package includes an installation script to install and setup the required components.

<a href="https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/screenshots/v283/screenshot-283-2.png?ref_type=heads" target="_blank"><img src="screenshots/v283/screenshot-283-2.png" /></a>

You can find the installation video (Version 2.7.1) on YouTube: <a href="https://youtu.be/kHG5czrQ7WA" target="_blank">Install Arch Linux with Hyprland & Qtile</a>

The ML4W Dotfiles are available as 

- main release (Official release): https://gitlab.com/stephan-raabe/dotfiles
- rolling release (Development release): https://gitlab.com/stephan-raabe/dotfiles/-/tree/dev

[TOC]

# Installation

To make it easy for you to get started with the ML4W dotfiles, here's a list of recommended next steps.

The package includes an installation script install.sh that will guide you through all steps of the installation or update process.

PLEASE NOTE: Every Linux distribution and setup can be different. Therefore, I cannot guarantee that the installation will work smoothly everywhere. Installation on your own risk.

## Supported platforms

The dotfiles are tested with the following Arch based distributions:

- Arch Linux (recommended)
- EndeavourOS
- Arco Linux
- Manjaro Linux

The installation should work on all Arch Linux based distributions as well.

For Manjaro users: Hyprland and required components are under ongoing development. That's why it's possible that some packages are not immediatly available on Manjaro e.g., hyprlock or hypridle. But usually, the packages will be published later.

For Arco Linux users: Please reinstall/force the installation of all packages during the installation/update process of the install script. The script will also offer to remove ttf-ms-fonts if installed to avoid issues with icons on waybar. 

## Before you start

PLEASE BACKUP YOUR EXISTING .config FOLDER WITH YOUR DOTFILES BEFORE STARTING THE SCRIPTS FOR INITIAL INSTALLTION.

The installation script will create a backup from an previous dotfiles installation.

## Reference Installation

The reference installation for the ML4W dotfiles is based on Arch Linux installed with archinstal and the minimal profile. 

Please watch the video on YouTube: https://youtu.be/kHG5czrQ7WA

## Installation with GIT

```
# 1.) Change into your Downloads folder (create the folder if not available)
cd ~/Downloads

# 2.) Clone the dotfiles repository into the Downloads folder
git clone --depth=1 https://gitlab.com/stephan-raabe/dotfiles.git

# 3.) Change into the dotfiles folder
cd dotfiles

# 4.) Start the installation
./install.sh

```

## Installation with GIT of the rolling release

```
# 1.) Change into your Downloads folder (create the folder if not available)
cd ~/Downloads

# 2.) Clone the dotfiles repository into the Downloads folder
git clone https://gitlab.com/stephan-raabe/dotfiles.git

# 3.) Change into the new dotfiles folder
cd dotfiles

# 4.) Checkout the dev branch
git checkout dev

# 4.) Start the installation
./install.sh

```

## Update

From 2.8.2 onwards you can use the integrated update feature to update your dotfiles to the main or rolling release whenever you want.

<img src="screenshots/welcome-update-dotfiles.png" />

You can also use the ML4W installer to update to the main-release (Latest Version) or the Rolling Release: https://gitlab.com/stephan-raabe/installer

You can force a clean re-installation of the dotfiles by removing the folder ~/dotfiles before starting the installation.

Please note that you can create a backup of your existing configuration with the backup feature of the install script. It's recommended to remove the folder ~/dotfiles only after creating a backup. 

Please follow the steps to update from earlier dotfiles versions to 2.8.3

```
# 1.) Remove existing downloaded dotfiles
rm -rf ~/Downloads/dotfiles

# 2.) Change into your Downloads folder
cd ~/Downloads

# 3.) Clone the dotfiles repository into the Downloads folder
git clone --depth=1 https://gitlab.com/stephan-raabe/dotfiles.git

# 4.) Change into the dotfiles folder
cd dotfiles

# 5.) Start the installation
./install.sh

```

## ML4W dotfiles Installer

You can also use the ML4W dotfiles installer script to download and install the latest release: https://gitlab.com/stephan-raabe/installer

## Installation Hook

The installation script will prepare the configuration files in a folder ~/dotfiles-versions/[version] before copy the files into the final destination in ~/dotfiles

If you want to modify the installation files just before everytime the copy procedure starts, you can create a file hook.sh in the folder ~/dotfiles-versions

You can for example delete folders and files or update existing configurations.

```
#!/bin/bash
rm -rf ~/dotfiles-versions/$version/vim/
rm -rf ~/dotfiles-versions/$version/nvim/
```

This script will for example remove the vim and nvim folder before the installation. The symbolic link will not be created because the source folder doesn't exits.

You can find a template in .install/templates/hook.sh

## Hyprland & NVIDIA 

There is no official Hyprland support for Nvidia hardware. However, you might make it work properly following this page.
https://wiki.hyprland.org/Nvidia/

Users have reported that Hyprland with dotfiles could be installed successfully on setups with NVDIA GPUs using the nouveau open source drivers. 

Please select the following variation in the settings script (system/environment):

https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/hypr/conf/environments/nvidia.conf

Or set the included environment variables in hyprland.conf

## Launch Hyprland from tty

The suggested method to start Hyprland is from tty with the command Hyprland because login managers (display managers) are not officially supported (https://wiki.hyprland.org/Getting-Started/Master-Tutorial/#launching-hyprland)

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

## Screenlock and suspend

Hypridle will start Hyprlock after 10 minutes of inactivity and will try to suspend one minutes later.

In the ML4W welcome app you can switch between a Laptop (systemctl) and Desktop PC configuration (dpms). The prepared hypridle templates are stored in /hypr/conf/hypridle/ and will overwrite the file /hypr/hypridle.conf

The selected hypridle configuration can be restored from the ML4W installer during a dotfiles update.

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

After starting the ML4W dotfiles for the first time, the ML4W Welcome App opens. This app is the starting point to discover the Hyprland setup.

<img src="screenshots/screenshot-welcome.app.png" />

The welcome screen includes the most important keybindings to open a terminal or a browser.

You can start the ML4W Welcome App by clicking on the L icon on the right side in waybar, using the rofi application launcher or by typing ml4w in your terminal (if you're using the .bashrc from the dotfiles).

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

## ML4W Dotfiles Settings App

You can open the ML4W dotfiles settings app with <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd> to change selected dotfiles configurations and choose from variations for your hyprland.conf to customize your desktop even more.

<img src="screenshots/screenshot-dotfiles-settings-app.png" />

You can create custom variations by copying a file from the ~/dotfiles/hypr/conf subfolders like monitor/default.conf, give the file a custom name (e.g., mymonitor.conf) and select the variation in the dotfiles settings app in the corresponding section.

You can also edit the file custom.conf which is included at the bottom of the hyprland.conf and can hold you personal configurations.

## Wallpaper and Pywal

Included is a pywal configuration that changes the color scheme based on a randomly selected wallpaper. With the key binding <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>W</kbd> you can change the wallpaper coming from the folder ~/wallpaper/. 

<kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>W</kbd> opens rofi with a list of installed wallpapers in ~/wallpaper/ for your individual selection. 

## Waybar themes and themeswitcher

In addition, you can switch the Waybar Template with <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>T</kbd> or by pressing the "..." icon in Waybar with the themeswitcher. 

The templates are available in ~/dotfiles/waybar/themes. You can add your own personal themes into this folder. 

More information here: https://gitlab.com/stephan-raabe/dotfiles/-/tree/main/waybar

## Screensharing and recording

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

## hypridle and hyprlock is not starting after an update of the dotfiles

Please make sure that hypridle and hyprlock has been installed successfully with

```
yay -S hypridle hyprlock
```

If there is an file conflict the remove the files manually with:

```
sudo rm /usr/lib/debug/usr/bin/hypridle.debug
sudo rm /usr/lib/debug/usr/bin/hyprlock.debug
```

and start the installation again with

```
yay -S hypridle hyprlock
```

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
