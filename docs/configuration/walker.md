# Activate Walker (optional)

The ML4W Dotfiles include an option to replace the launcher rofi with walker (except screenshot options).

![image](/walker.jpg)

## Install Walker

```bash
# Arch Linux
yay -S walker-bin
yay -S elephant
yay -S elephant-desktopapplications
yay -S elephant-files
yay -S elephant-menus
```

```bash
# Fedora
sudo dnf copr enable errornointernet/walker
sudo dnf install walker
sudo dnf install elephant
```

```bash
# openSuse Tumbleweed

# Dependencies
sudo zypper install git cargo gtk4-devel gtk4-layer-shell-devel libpoppler-glib-devel protobuf-devel cairo-devel go make

# Walker
git clone https://github.com/abenz1267/walker.git ~/Downloads/walker
cd ~/Downloads/walker
sudo make install

# Elephant
git clone https://github.com/abenz1267/elephant ~/Downloads/elephant
cd ~/Downloads/elephant
sudo make install

# Provider desktopapplications
cd ~/Downloads/elephant/internal/providers/desktopapplications
sudo make install

# Provider menus
cd ~/Downloads/elephant/internal/providers/menus
sudo make install

# Provider files
cd ~/Downloads/elephant/internal/providers/files
sudo make install

```
## Activate Walker

Open the ML4W Settings folder:

cd ~/.config/ml4w/settings

Open the file `launcher` and replace `rofi` with `walker`

Reboot your system.

## Walker/Elephant Documenation

https://github.com/abenz1267/walker

https://github.com/abenz1267/elephant
