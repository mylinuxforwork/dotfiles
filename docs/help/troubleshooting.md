# Globbing errors on startup

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

![image](/troubleshoot.png)

Please change the wallpaper with `SUPER+SHIFT+W`.

If this doesn't fix it please open the application launcher and start waypaper. 

Select any other wallpaper and reboot your system.

The issue should be solved.

</div>

## Issues with SDDM Sequoia Theme

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

If you notice an error with the new Sequoia theme, you can uninstall the theme with

```sh
sudo rm -rf /usr/share/sddm/themes/sequoia
```

</div>

## Check that all key packages and commands are available

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

The ML4W Welcome App includes a system diagnosis feature available in the menu with the three dots.

Or open the script in a terminal with

```sh
ml4w-diagnosis
```

Please run the diagnosis to see if all essential packages and related commands are available on your system.

If not, you need to install the missing packages manually.

</div>

## At the end of the update from earlier versions to `2.9.5` or higher I see an error message in the terminal

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

This is not a problem. Just reboot as suggested after the update and the error message is gone. 

From `2.9.5` onwards the ML4W Dotfiles will be installed in a new file structure and the `starship.toml` has been moved to another location. 

</div>

## Waybar is not loading

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

The effect that waybar isn't loading usually happens after a fresh installation of the ML4W Dotfiles. The reason is the start of the `xdg-desktop-portal-gtk` process. It also can happen when you start Hyprland from tty the second time.

If waybar is not loading, the first thing that you should try is to reboot your system and try again. 

You can open a terminal with `SUPER+Return` and enter wlogout.

If it's still not working please try to uninstall `xdg-desktop-portal-gtk`

```sh
sudo pacman -R xdg-desktop-portal-gtk
```

Reboot your system again. 

Waybar should working now but you will loose the dark mode in Libadwaita apps e.g., `nautilus`. The ML4W Apps will still work in dark mode.

Then try to install it again with

```sh
sudo pacman -S xdg-desktop-portal-gtk
```

Please also make sure that `xdg-desktop-portal-gnome` is not installed in parallel to `xdg-desktop-portal-gtk`. Please try to remove the package then.

If there is still this issue, please uninstall `xdg-desktop-portal-gtk`. If dark mode is required install `dolphin`, `qt6ct` and enable breeze and darker colors to get a filemanager in dark mode.

</div>

## No dark theme on GTK4 apps

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

The package `xdg-desktop-portal-gtk` is not installed. 

Can be installed with the Post Installation Script from the ML4W Welcome App - 3 dots menu.

Or with

```sh
sudo pacman -S xdg-desktop-portal-gtk
```

And then reboot your system.

</div>

## Add noto-fonts-cjk to ml4w-hyprland-git Dependencies for Proper CJK Character Rendering

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

On Arch Linux, Chinese, Japanese, and Korean (CJK) characters display as unreadable squares or pixelated text in some applications.

Install the `noto-fonts-cjk` package with:

```sh
sudo pacman -S noto-fonts-cjk
```

This package provides proper rendering for CJK characters across the system.

</div>

## Rofi (application launcher) is not working

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

If the installation of `rofi-wayland` fails in the installation/update procedure please try to install it manually:

```sh
yay -S rofi-wayland
```

If rofi-wayland isn't available please try rofi:

```sh
yay -S rofi
```

</div>

## Hypridle and hyprlock is not starting after an update of the dotfiles

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

Please make sure that `hypridle` and `hyprlock` has been installed successfully with

```sh
yay -S hypridle hyprlock
```

If there is an file conflict the remove the files manually with:

```sh
sudo rm /usr/lib/debug/usr/bin/hypridle.debug
sudo rm /usr/lib/debug/usr/bin/hyprlock.debug
```

and start the installation again with

```sh
yay -S hypridle hyprlock
```

</div>

## GTK apps not using dark theme

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

Please try to install `xdg-desktop-portal-gtk`

```sh
sudo pacman -S xdg-desktop-portal-gtk
```

You can also try to remove `xdg-desktop-portal-gtk` and reinstall it again.

</div>

## Missing icons in waybar

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

In case of missing icons on waybar, it's due to a conflict between several installed fonts (can happen especially on **Arco Linux**). Please make sure that `ttf-ms-fonts` is uninstalled and `ttf-font-awesome` and `otf-font-awesome` are installed with

```sh
yay -R ttf-ms-fonts
yay -S ttf-font-awesome otf-font-awesome
```

</div>

## SDDM not showing (only black screen with cursor)

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

Switch to another tty with `CTRL + ALT + F3` Now you can login with your user.

Start Hyprland with Hyprland.

You can try to reinstall all sddm related packages.

```sh
yay -S sddm-git sddm-sugar-candy-git
```

Or you can install another display manager.

To stop, disable and remove sddm service.

```sh
sudo systemctl stop sddm.service
sudo systemctl disable sddm.service
sudo rm /etc/systemd/system/display-manager.service
```

</div>
