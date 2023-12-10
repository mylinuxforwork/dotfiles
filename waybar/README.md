## Theme Switcher

Select a theme with SUPER + CTRL + T (custom Hyprland key binding) to execute the themeswitcher.sh script. The script will open rofi to show the themes in the folder ~/dotfiles/waybar/themes/

## Waybar Documentation

Waybar github: https://github.com/Alexays/Waybar
Waybar Wiki: https://github.com/Alexays/Waybar/wiki

## Define your own config and style.css for a ML4W theme

If you want to hide modules from the dotfiles ML4W themes or tweak the style, you can do this by creating a copy of the config file and name it config-custom or a copy of style.css and name it style-custom.css

The waybar loader will the use your copies instead of the default files.

With a personal config-custom you can also load a personal modules.json with additional modules.

You can reload the waybar theme with <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>B</kbd>

## Create your own theme based on the starter theme

Please check the configurations of the folders in ~/dotfiles/waybar/themes/

A good starting point is to copy the the waybar starter theme.

Copy the folder ~/dotfiles/waybar/themes/starter and name the copy for example to mytheme.

Open the file ~/dotfiles/waybar/themes/mytheme/config.sh and give your theme a name 

```
#!/bin/bash
theme_name="MyTheme"
```

Select your new theme by clicking in the ... icon or with <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>T</kbd>

To customize your theme, you can edit the files config, style.css and modules.json 

You can reload the waybar theme with <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>B</kbd>

## Waybar documentation

Waybar configuration: https://github.com/Alexays/Waybar/wiki/Configuration
Waybar Styling: https://github.com/Alexays/Waybar/wiki/Styling
