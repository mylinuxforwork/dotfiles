# Activate Walker (optional)

The ML4W Dotfiles include an option to replace rofi as launcher with walker (except screenshot options).

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

## Activate Walker

Open the ML4W Settings folder:

cd ~/.config/ml4w/settings

Open the file `launcher` and replace `rofi` with `walker`

Reboot your system.

## Walker/Elephant Documenation

https://github.com/abenz1267/walker

https://github.com/abenz1267/elephant
