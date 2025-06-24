# ML4W Dotfiles for Hyprland

An advanced configuration of Hyprland for Arch Linux based distributions. Full desktop environment based on the tiling window manager Hyprland with dynamic material color themes based on your wallpaper for all main modules and comprehensive apps to customize your configuration.

This package includes an installation script to install and set up the required components.

![image](https://github.com/user-attachments/assets/f5f80750-fa35-4631-8d2d-62f7f937412a)

> About the screenshot: The dock can be enabled in the ML4W Sidebar or Settings app. The waybar theme is ML4W Modern Light.

YouTube Video https://youtu.be/gtjzAjt39Og

## Installation

The installation should work on all Arch Linux and Fedora based distributions. You can find more information on [Ml4W-Hyprland wiki](https://mylinuxforwork.github.io/dotfiles/). <!-- migrate to vitepress wiki site -->

I recommend to install a base Hyprland system before installing the ML4W Hyprland Dotfiles. Then you have a stable starting point and can test Hyprland on your system beforehand. Hyprland is complex, under ongoing development, and requires additional components.

You can find the Hyprland Installation instructions on [official hyprland wiki](https://wiki.hyprland.org/Getting-Started/Installation/ )

> [!IMPORTANT]
> Please make sure that all packages on your system are updated before running the installation script.

> [!NOTE]
> Every Linux distribution, setup, and personal configuration can be different. Therefore, I cannot guarantee that the ML4W Dotfiles will work everywhere. You install at your own risk.

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

Tested on Fedora Workstation 41 and 42.

```shell
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-fedora.sh)
```

## Troubleshooting

You can find solutions to common issues in the wiki [troubleshooting section](https://mylinuxforwork.github.io/dotfiles/help/troubleshooting.html) <!-- migrate to vitepress wiki site -->

## Documentation

You can find the complete guide of the ML4W Dotfiles in the [Ml4W-Hyprland wiki](https://mylinuxforwork.github.io/dotfiles/) <!-- migrate to vitepress wiki site -->

## Contributing

Thanks for using the ML4W Dotfiles on your system. If you find a problem or a bug, please [report your issue on this page](https://github.com/mylinuxforwork/dotfiles/issues).

You can also visit the [ML4W Discord Server](https://discord.gg/c4fJK7Za3g) to start a discussion with other users.

## Contributors 

Thanks to all the contributors who helped find bugs, test, refine, and submit PRs. Your valuable efforts are truly appreciated! 💖 

[![contributors](https://contrib.rocks/image?repo=mylinuxforwork/dotfiles)](https://github.com/mylinuxforwork/dotfiles/graphs/contributors)

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
