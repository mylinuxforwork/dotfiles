## Theme Switcher

Select a theme with SUPER + CTRL + T (custom Hyprland key binding) to execute the themeswitcher.sh script. The script will open rofi to show the themes in the folder ~/dotfiles/waybar/themes/

## Waybar Documentation
Waybar github: https://github.com/Alexays/Waybar
Waybar Wiki: https://github.com/Alexays/Waybar/wiki

## Create your own theme

Please check the configurations of the folders in ~/dotfiles/waybar/themes/
Create a folder for your theme and add your configuration. 
A good starting point is to copy the default folder with the default waybar theme.

The main theme folder includes the core config file and stylesheet.
Waybar configuration: https://github.com/Alexays/Waybar/wiki/Configuration

Create subfolders to save variations like in the folder ml4w. You can include stylesheets from other themes to standardize your themes like in the theme ml4w-bottom.

## Stylesheet

The style.css includes the style file of the theme. 
Waybar Styling: https://github.com/Alexays/Waybar/wiki/Styling

## Define theme name

Add a config.sh file to save the theme name. Add it to the main or subfolders for variations.

```
#!/bin/bash
theme_name="ML4W Light"
```


