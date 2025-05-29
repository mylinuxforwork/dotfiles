## Wallpaper with hyprpaper and Pywal (swww optional supported)

Included is a pywal configuration that changes the color scheme based on a randomly selected wallpaper. With the key binding <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>W</kbd> you can change the wallpaper stored in the folder ~/wallpaper/. 

> [!NOTE]
> Please make sure I don't have a space in the file name. Pywal will then not be able to generate the color scheme.

<kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>W</kbd> opens waypaper with thumbnails of installed wallpapers in ~/wallpaper/ for your individual selection. 

![image](/wallpapers.png)

In waypaper you can select a wallpaper from any folder of your system.

The default wallpaper engine is hyprpaper. But you can optionally install swww manually and switch in the ML4W Dotfiles Settings app from hyprpaper to swww.
Open the ML4W Dotfiles Settings app and select the tab system. At the top you can find the Wallpaper Engine Selector.

> [!NOTE]
> A logout and login is required to activate the new wallpaper application.

The hyprpaper engine uses a template stored in dotfiles/.settings/hyprpaper.tpl You can add additional configurations there. The WALLPAPER placeholder will be replaced with the current wallpaper.

## Wallpaper Automation

You can activate an automated wallpaper change with the key binding <kbd>SUPER</kbd> + <kbd>ALT</kbd> + <kbd>W</kbd>. The automated wallpaper process can be stopped with the same key binindg.

The delay time in seconds between the wallpaper change (default 60 seconds) can be set in `~/.config/ml4w/settings/wallpaper-automation.sh`

## Wallpaper Effects

You can enable wallpaper effects to completely change the visualization of your selected wallpaper. Right click on the wallpaper icon in waybar will open a menu to select the wallpaper effect.

![Screenshot](/wall-effect.png)

You can add you own effects in the folder /dotfiles/hypr/effects/wallpaper

You can execute multiple magick commands. $wallpaper is the selected wallpaper, $used_wallpaper the executed wallpaper.

```sh
magick $wallpaper -negate $used_wallpaper
magick $used_wallpaper -brightness-contrast -20% $used_wallpaper
```

## Wallpaper Cache

Generated versions of a wallpaper will be cached in the folder `~/.config/ml4w/cache/wallpaper-generated`
This will speed up the switch between wallpapers if cached files exist. 

You can disable the cache in the ML4W Settings App.

You can clear the cache in the ML4W Settings App or with 

```sh
~/.config/hypr/scripts/wallpaper-cache.sh
```

You can regenerate the version of the current wallpaper by switching of the cache in the settings app and select the same wallpaper again.

## Wallpaper for sddm

You can set the current used wallpaper as background image for the display manager sddm by using the shown function in the ML4W Sidebar App:

![image](https://github.com/user-attachments/assets/8dd0b173-b750-4da8-b1ea-0cc8a32bbd69)

## The ML4W Wallpaper repository

You can download more wallpapers here: https://github.com/mylinuxforwork/wallpaper/blob/main/README.md

