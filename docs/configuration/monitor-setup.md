# Monitor Setup

If you want to change the default monitor configuration, you can setup your own personal monitor variation or use nwg-displays.

## Personal Monitor Variation

Please open the ML4W Dotfiles Settings App and select the system tab. When you scroll down you can see shipped monitor monitor variation.

![image](/monitor.png)

You can also create your own variation as described [here](https://github.com/mylinuxforwork/dotfiles/wiki/Configuration-Variations).

<!-- maybe update this wiki link in the future -->

## Use nwg-displays

The ML4W Dotfiles are supporting the application [nwg-displays](https://github.com/nwg-piotr/nwg-displays) to configure your display settings.

Install nwg-displays on your distribution with:

::: code-group

```sh [<i class="devicon-archlinux-plain"></i> Arch]
sudo pacman -S nwg-displays
```

```sh [<i class="devicon-fedora-plain"></i> Fedora]
sudo dnf install python-build python-installer python-wheel python-setuptools
git clone https://github.com/nwg-piotr/nwg-displays ~/nwg-displays
cd ~/nwg-displays && chmod +x install.sh
sudo ./install.sh
```
```sh [<i class="devicon-opensuse-plain"></i> openSuse]
sudo zypper install nwg-displays
```


:::

Open the app and apply your desired monitor settings.

![image](/monitor1.png)

Then open the ML4W Settings App and select the Monitor Variation nwg-displays.

![image](/monitor2.png)

> From now on you can change your monitor configuration directly in nwg-displays.

