If you want to change the default monitor configuration, you can setup your own personal monitor variation or use nwg-displays.

## Personal Monitor Variation

Please open the ML4W Dotfiles Settings App and select the system tab. When you scroll down you can see shipped monitor monitor variation.

![image](/monitor.png)

You can also create your own variation as described here: https://github.com/mylinuxforwork/dotfiles/wiki/Configuration-Variations

## Use nwg-displays

The ML4W Dotfiles are supporting the application nwg-displays (https://github.com/nwg-piotr/nwg-displays) to configure your display settings.

Install nwg-displays on Arch Linux with

::: code-group

```sh [Arch]
sudo pacman -S nwg-displays
```

```sh [Fedora]
sudo dnf install nwg-displays
```
:::

Open the app and apply your desired monitor settings.

![image](/monitor1.png)

Then open the ML4W Settings App and select the Monitor Variation nwg-displays.

![image](/monitor2.png)

From now on you can change your monitor configuration directly in nwg-displays.

