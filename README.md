# ML4W Dotfiles for Hyprland

An advanced configuration of Hyprland for Arch Linux based distributions. This package includes an installation script to install and set up the required components.

![screenshot_24042025_164752](https://github.com/user-attachments/assets/03b72f0d-8009-4928-8eb1-b999987def8e)

> About the screenshot: The dock can be enabled in the ML4W Sidebar or Settings app. The waybar theme is ML4W Modern White.

YouTube Video https://youtu.be/sVFnd5LAYAc

## Installation

The installation should work on all Arch Linux and Fedora based distributions. [You can find more information here](https://github.com/mylinuxforwork/dotfiles/wiki).

I recommend to install a base Hyprland system before installing the ML4W Hyprland Dotfiles. Then you have a stable starting point and can test Hyprland on your system beforehand. Hyprland is complex, under ongoing development, and requires additional components.

You can find the Hyprland Installation instructions here: https://wiki.hyprland.org/Getting-Started/Installation/

> IMPORTANT: Please make sure that all packages on your system are updated before running the installation script.

> PLEASE NOTE: Every Linux distribution, setup, and personal configuration can be different. Therefore, I cannot guarantee that the ML4W Dotfiles will work everywhere. You install at your own risk.

### Arch Linux (based)

Recommended is to install the Hyprland Desktop Profile from archinstall first.

```shell
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh)
```

YouTube Video https://youtu.be/sVFnd5LAYAc

You can also install the main release with your preferred AUR helper.

```shell
yay -S ml4w-hyprland
ml4w-hyprland-setup
```

You can install the rolling release with

```shell
yay -S ml4w-hyprland-git
ml4w-hyprland-setup
```

Please rebuild all packages to ensure that you get the latest commit.

### Fedora Linux (based)

```shell
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-fedora.sh)
```

## Troubleshooting

You can find solutions to common issues in the Wiki troubleshooting section: https://github.com/mylinuxforwork/dotfiles/wiki/Troubleshooting

## Documentation (Wiki)

You can find the complete documentation of the ML4W Dotfiles in the Wiki. <b>[Open the Wiki here](https://github.com/mylinuxforwork/dotfiles/wiki)</b>

## Contributing

Thanks for using the ML4W Dotfiles on your system. If you find a problem or a bug, please [report your issue on this page](https://github.com/mylinuxforwork/dotfiles/issues).

You can also visit the [ML4W Discord Server](https://discord.gg/c4fJK7Za3g) to start a discussion with other users.

## Screenshots

![screenshot_06022025_165339](https://github.com/user-attachments/assets/2d281632-762f-465c-99e2-6933f1507cac)

![image](https://github.com/user-attachments/assets/c1af2d8a-142b-4285-9b63-92862a7868c5)

## Wallpaper repository

You can find my wallpaper collection in the repository https://github.com/mylinuxforwork/wallpaper

## Inspirations

The following projects have inspired me:

- https://github.com/JaKooLit/Hyprland-Dots
- https://github.com/prasanthrangan/hyprdots
- https://github.com/sudo-harun/dotfiles
- https://github.com/dianaw353/hyprland-configuration-rootfs

and many more...
