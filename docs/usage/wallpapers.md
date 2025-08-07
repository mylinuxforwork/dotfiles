# Wallpaper with waypaper (hyprpaper and swww as option)

You can select a wallpaper with Waypaper. You can start Waypaper from the App Launcher or from the sidebar.

> [!NOTE]
> You can install more wallpapers from the ML4W Wallpaper Repository: https://github.com/mylinuxforwork/wallpaper

### 🎨 Wallpaper Keybindings

| Keybind | Action |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>W</kbd> | Change wallpaper (random from `~/wallpaper/`) |
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>W</kbd> | Open Waypaper |
| <kbd>SUPER</kbd> + <kbd>ALT</kbd> + <kbd>W</kbd> | Start/Stop wallpaper automation |

![image](/wallpapers.png)

> In waypaper you can select a wallpaper from any folder of your system.

> The default wallpaper engine is **`hyprpaper`**. But you can optionally install **swww** manually and switch in the ML4W Dotfiles Settings app from hyprpaper to swww.  

>Open the ML4W Dotfiles Settings app and select the tab system. At the top you can find the Wallpaper Engine Selector.

> [!NOTE]  
> A logout and login is required to activate the new wallpaper application.

The hyprpaper engine uses a template stored in `dotfiles/.settings/hyprpaper.tpl`. You can add additional configurations there. The `WALLPAPER` placeholder will be replaced with the current wallpaper.

## Wallpaper Automation

You can activate an automated wallpaper change with the key binding above. The automated wallpaper process can be stopped with the same key binindg.

The delay time in seconds between the wallpaper change (default 60 seconds) can be set in `~/.config/ml4w/settings/wallpaper-automation.sh`

## Wallpaper Effects

You can enable wallpaper effects to completely change the visualization of your selected wallpaper. Right click on the wallpaper icon in waybar will open a menu to select the wallpaper effect.

![Screenshot](/wall-effect.png)

You can add you own effects in the folder `/dotfiles/hypr/effects/wallpaper`

You can execute multiple `magick` commands. `$wallpaper` is the selected wallpaper, $used_wallpaper the executed wallpaper.

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

## The ML4W Wallpaper repository

You can download more wallpapers [ML4W Wallpaper repository](https://github.com/mylinuxforwork/wallpaper/blob/main/README.md)

