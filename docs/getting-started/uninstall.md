## Removing your configuration

![image](/uninstall.png)

You can use the integrated uninstallation function (ML4W Dotfiles Uninstaller App) to remove the ML4W Dotfiles from your system.

Please select "Uninstall Dotfiles" from the ML4W Welcome App or execute `ml4w-hyprland-setup -m uninstall`

The ML4W Dotfiles Uninstaller will remove the dotfiles folder, related symbolic links and the desktop files of the ML4W Apps.

The script will also try to restore old configurations back into .config if available and restored during the installation of the ML4W Dotfiles.

## Removing the package

You can use your AUR Helper to uninstall the ML4W Dotfiles:

::: code-group

```sh [Stable]
yay -R ml4w-hyprland
```

```sh [Rolling]
yay -R ml4w-hyprland-git
```

:::

