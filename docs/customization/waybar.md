The status bar for the ML4W Dotfiles is **Waybar**. You can find the waybar configuration in `~/dotfiles/waybar`.

### Waybar Keybindings

| Keybind | Action |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>B</kbd> | Toggle Waybar |
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>B</kbd> | Reload Waybar Theme |
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>T</kbd> | Switch Waybar Theme via themeswitcher |
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>T</kbd> | Open Rofi themeswitcher for Waybar |

## Waybar Themes and themeswitcher

| Select a theme                |
|------------------------------|
| Use <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>T</kbd> (custom Hyprland key binding) to execute the `themeswitcher.sh` script. The script opens Rofi to show themes in `~/.config/waybar/themes/`. |

## Define your Quicklinks

The waybar status bar includes a section for quicklinks. 

![image](/bar.png)

The icon for ChatGPT and Settings are fixed. All the other icons can be customized or extended in `~/.config/ml4w/settings/waybar-quicklinks.json`

In the JSON file you can define up to 10 Quicklinks and add them into the quicklinks group in Waybar:
https://github.com/mylinuxforwork/dotfiles/blob/main/share/dotfiles/.config/ml4w/settings/waybar-quicklinks.json

```sh
/*
Define your quick links for the statusbar here.
YOu can use icons from here https://fontawesome.com/search?ic=free
You can reload waybar with SUPER + SHIFT + B
*/
{
    "custom/quicklink_browser": {
        "format": "",
        "on-click": "~/.config/ml4w/settings/browser.sh",
        "tooltip-format": "Open Browser"
    },
    "custom/quicklink_filemanager": {
        "format": "",
        "on-click": "~/.config/ml4w/settings/filemanager.sh",
        "tooltip-format": "Open Filemanager"
    },
    "custom/quicklink_email": {
        "format": "",
        "on-click": "~/.config/ml4w/settings/filemanager.sh",
        "tooltip-format": "Open Email Client"
    },
    "custom/quicklink_chromium": {
        "format": "",
        "on-click": "chromium",
        "tooltip-format": "Open Chromium"
    },
    "custom/quicklink_edge": {
        "format": "",
        "on-click": "edge",
        "tooltip-format": "Open Edge"
    },
    "custom/quicklink_firefox": {
        "format": "",
        "on-click": "firefox",
        "tooltip-format": "Open Firefox"
    },
    "custom/quicklink_thunderbird": {
        "format": "",
        "on-click": "thunderbird",
        "tooltip-format": "Open Thunderbird"
    },
    "custom/quicklink_calculator": {
        "format": "",
        "on-click": "~/.config/ml4w/settings/calculator.sh",
        "tooltip-format": "Open calculator"
    },
/*
Don't remove the quicklinkempty
*/
    "custom/quicklinkempty": {
    },
/*
Add your quicklinks in your desired order to the status bar
*/
    "group/quicklinks": {
        "orientation": "horizontal",
        "modules": [

            "custom/quicklink_browser",
            "custom/quicklink_email",
            "custom/quicklink_filemanager",

/*
Don't remove the quicklinkempty
*/
            "custom/quicklinkempty"
        ]
    }
}
```
This configuration includes already a prepared quicklink for Firefox incl. the correct icon. Just activate it by removing the /* */ and remove Chromium.

| Reload after changes          |
|------------------------------|
| After changing the file, reload Waybar with <kbd>`SUPER`</kbd> + <kbd>`SHIFT`</kbd> + <kbd>`B`</kbd>. |

You can find free icons of font-awesome on [fontawesome.com](https://fontawesome.com/search?o=r&m=free)

## Define your own config and style.css for a ML4W theme

If you want to hide modules from the dotfiles ML4W themes or tweak the style, you can do this by creating a copy of the config file and name it config-custom or a copy of `style.css` and name it `style-custom.css`

The waybar loader will the use your copies instead of the default files.

With a personal config-custom you can also load a personal modules.json with additional modules.

## Create your own theme based on the starter theme

Please check the configurations of the folders in `~/dotfiles/waybar/themes/`

A good starting point is to copy the the waybar starter theme.

Copy the folder `~/.config/waybar/themes/starter` and name the copy for example to mytheme.

Open the file `~/.config/waybar/themes/mytheme/config.sh` and give your theme a name 

```sh
#!/bin/bash
theme_name="MyTheme"
```

| How to select new theme       |
|------------------------------|
| Select your new theme by clicking the "..." icon in Waybar or using <kbd>`SUPER`</kbd> + <kbd>`CTRL`</kbd> + <kbd>`T`</kbd>. |

To customize your theme, you can edit the files config, `style.css` and `modules.json` 

| Reload theme shortcut         |
|------------------------------|
| You can reload the Waybar theme with <kbd>`SUPER`</kbd> + <kbd>`SHIFT`</kbd> + <kbd>`B`</kbd>. |

## Waybar documentation

- Waybar configuration: https://github.com/Alexays/Waybar/wiki/Configuration
- Waybar Styling: https://github.com/Alexays/Waybar/wiki/Styling

