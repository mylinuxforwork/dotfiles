# Troubleshooting

## Issues with SDDM Sequoia Theme

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

If you notice an error with the new Sequoia theme, you can uninstall the theme with

```sh
sudo rm -rf /usr/share/sddm/themes/sequoia
```

Open from /etc/sddm.conf.d/sddm.conf and restore back the default theme.

```sh
[Theme]
Current=elarum
```
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

## Missing icons in waybar

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

In case of missing icons on waybar, it's due to a conflict between several installed fonts (can happen especially on **Arco Linux**). Please make sure that `ttf-ms-fonts` is uninstalled and `ttf-font-awesome` and `otf-font-awesome` are installed with

```sh
yay -R ttf-ms-fonts
yay -S ttf-font-awesome otf-font-awesome
```

</div>
