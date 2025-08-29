# Dotfiles Settings

You can open the ML4W dotfiles settings app with `SUPER + CTRL + S` to change selected dotfiles configurations and choose from variations for your hyprland.conf to customize your desktop even more.

![Screenshot](/settings.jpg)

You can create custom variations by copying a file from the `~/dotfiles/hypr/conf` subfolders like `monitor/default.conf`, give the file a custom name (e.g., `mymonitor.conf`) and select the variation in the dotfiles settings app in the corresponding section.

> [!IMPORTANT]
> The ML4W Dotfiles Settings App replaces strings from several configuration files directly or based on replacement comments e.g., // START WORKSPACES That's why you shouldn't remove any of theses comments or markers to ensure full functionality of the app.

You can also edit the file `custom.conf` which is included at the bottom of the `hyprland.conf` and can hold you personal configurations.

You can find the sourcecode in [ML4W Dotfiles Settings App repository](https://github.com/mylinuxforwork/dotfiles-settings)

You can also start the Dotfiles App from the terminal with 

```sh
ml4w-settings
```
