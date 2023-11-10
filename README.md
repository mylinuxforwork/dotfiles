# ML4W dotfiles Version 2.5

This is my configuration of Hyprland (Wayland) and Qtile (Xorg & Wayland).
This package includes an installation script to install and setup the required components.

The dotfiles are tested with Arch Linux, Manjaro Linux, EndeavourOS and Arco Linux.

## General Packages

- Terminal: alacritty
- Editor: nvim
- Prompt: starship
- Icons: Font Awesome
- Launch Menus: Rofi
- Colorscheme: pywal
- Browsers: chromium (brave optional)
- Filemanager: Thunar
- Cursor: Bibata Modern Ice
- Icons: Papirus-Icon-Theme
- Virtual Machine: qemu (Windows 11 with looking glass and xrdp)

## Hyprland & Qtile Wayland

- Status Bar: waybar
- Screenshots: grim & slurp
- Clipboard Manager: cliphist
- Logout Hyprland: wlogout 
- Logout Qtile: rofi power menu
- Screenlock: swaylock-effects
- Qtile Bar: Qtile status bar

## Qtile X11

- Compositor: picom
- Status Bar: Qtile status bar + Polybar (optional)
- Screenshots: scrot

## Templating

Hyprland & Qtile: Included is a pywal configuration that changes the color scheme based on a randomly selected wallpaper. With the key binding SuperKey + Shift + w you can change the wallpaper. SuperKey + Ctrl + w opens rofi with a list of installed wallpapers for your individual selection. See also the .bashrc and the key bindings on Hyprland and Qtile for more alias definitions.

Hyprland: In addition, you can switch the Waybar Template with SUPER + CTRL + T or by pressing the "..." icon in Waybar. The templates are available in ~/dotfiles/waybar/themes. You can add your own personal themes into this folder. The script will read in the folder structure.

Qtile X11: In addition, you can switch between the Qtile status bar and Polybar with SUPER + SHIFT + S 

## Screenshots Hyprland

<a href="https://youtu.be/mJ9m18-7pQk" target="_blank"><img src="screenshots/v25/screenshot-25-5.png" alt="Click to watch on YouTube" /></a>

<a href="https://youtu.be/mJ9m18-7pQk" target="_blank"><img src="screenshots/v25/screenshot-25-6.png" alt="Click to watch on YouTube" /></a>

<a href="https://youtu.be/mJ9m18-7pQk" target="_blank">Watch on YouTube</a>

## Screenshots Qtile X11

<a href="https://youtu.be/mJ9m18-7pQk" target="_blank"><img src="screenshots/v25/screenshot-25-3.png" alt="Click to watch on YouTube" /></a>

<a href="https://youtu.be/mJ9m18-7pQk" target="_blank"><img src="screenshots/v25/screenshot-25-4.png" alt="Click to watch on YouTube" /></a>

<a href="https://youtu.be/mJ9m18-7pQk" target="_blank">Watch on YouTube</a>

## Screenshots Qtile Wayland

<a href="https://youtu.be/mJ9m18-7pQk" target="_blank"><img src="screenshots/v25/screenshot-25-1.png" alt="Click to watch on YouTube" /></a>

<a href="https://youtu.be/mJ9m18-7pQk" target="_blank"><img src="screenshots/v25/screenshot-25-2.png" alt="Click to watch on YouTube" /></a>

<a href="https://youtu.be/mJ9m18-7pQk" target="_blank">Watch on YouTube</a>

<b><a href="https://gitlab.com/stephan-raabe/dotfiles/-/tree/main/screenshots?ref_type=heads">You can find more screenshots here.</a></b>

## Installation

To make it easy for you to get started with my dotfiles, here's a list of recommended next steps.

PLEASE BACKUP YOUR EXISTING .config FOLDER WITH YOUR DOTFILES BEFORE STARTING THE SCRIPTS FOR INITIONAL INSTALLTION.

The script will try to create a backup from an older dotfiles folder.

```
# 1.) Change into your Downloads folder
cd ~/Downloads

# 2.) Clone the dotfiles repository into the Downloads folder
git clone https://gitlab.com/stephan-raabe/dotfiles.git

# 3.) Change into the dotfiles folder
cd dotfiles

# 4.) Start the installation
./install.sh

```

Please note that every Arch Linux system is different and I cannot guarantee that everything works fine on your system.
