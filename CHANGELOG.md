Version 2.9.2
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.9.2
--------------------------------------------------------
- Works with Hyprland 0.41.2
- Introducing waypaper as new wallpaper selector
- Wallpaper cache for generated wallpaper variants. Will speed up the change between wallpapers if cached files exists. https://gitlab.com/stephan-raabe/dotfiles/-/wikis/Home/Wallpapers#wallpaper-cache
- You can define custom quicklinks in waybar: https://gitlab.com/stephan-raabe/dotfiles/-/wikis/Home/Waybar#define-your-quicklinks
- New SVG icons in waybar for ML4W and ChatGPT
- Default waybar theme changed to ml4w-blur/white
- Alacritty: selected text will be copied to the primary clipboard
- General/standard Hyprland environment configuration moved to ml4w.conf (will be re-used in kvm.conf and nvidia.conf)
- The time format in hyprlock is now aligned with the waybar clock time format that is defined in the ML4W Settings App

Version 2.9.1.2
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.9.1.2
--------------------------------------------------------
- Workspaces module in waybar updated to enable scroll to change the workspace https://gitlab.com/stephan-raabe/dotfiles/-/merge_requests/114
- More functions deactivated in Game Mode (SUPER+ALT+G)
- Keybindings rofi menu updated with keybinding description. Open with right mouse click on Apps waybar module
- Fixed bug of ML4W Hyprland Settings App with Hyprland 0.41.0

Version 2.9.1.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.9.1.1
--------------------------------------------------------
- New installation method for sddm sugar candy theme. Instead of using yay, the installer will download the ZIP from the repository, extract it to the Downloads folder and copy the files to the destination folder.
- A gamemode can be toggled with SUPER+ALT+G. The gaming mode will disable the animations and blur.
- Added a black ML4W Icon for black waybar themes

Version 2.9.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.9.1
--------------------------------------------------------
- Hyprpaper is the default wallpaper engine. swww will not be installed by the installer anymore. You can still switch to swww in the Dotfiles Settings App (System tab) but you need to install swww manually with yay -S swww
- pfetch has been replaced with fastfetch (requires an update of the .bashrc) https://gitlab.com/stephan-raabe/dotfiles/-/issues/315
- Directory for wallpapers can be customized with new .settings/wallpaper-folder.sh https://gitlab.com/stephan-raabe/dotfiles/-/issues/325
- Screen shading possible with hyprshade. SUPER+SHIFT+S to toggle hyprshade. The shader can be defined with the shader module in waybar or in ~/dotfiles/.settings/hyprshade.sh 
For auto-activation at a dedicated time please set the filter to off and follow the instructions here https://github.com/loqusion/hyprshade. https://gitlab.com/stephan-raabe/dotfiles/-/issues/329
- Nautilus defined as the new default file manager. Thunar is still available.
- Waybar can be toggles with SUPER+CTRL+B https://gitlab.com/stephan-raabe/dotfiles/-/issues/299
- Installation script optimized for new gum
- During the installation of the keyboard, it can be selected between a desktop and laptop optimized configuration https://gitlab.com/stephan-raabe/dotfiles/-/issues/319. 
- RDP launch script updated https://gitlab.com/stephan-raabe/dotfiles/-/issues/336
- Nvidia environment configuration updated https://gitlab.com/stephan-raabe/dotfiles/-/issues/327
- Pacman can be configured for parallel downloads, colors and more during the installation and with the ML4W Settings app https://gitlab.com/stephan-raabe/dotfiles/-/issues/316
- Image conversions with imagemagick can be enabled for wallpapers. Right click on wallpaper module in waybar. You can add more effects in ~/dotfiles/hypr/effects/wallpaper
- ChatGPT Window opens on the left screen side in floating mode
- New default wallpaper 
- Added hypridle inhibitor waybar module to toggle screen locking with hyprlock
- Tooltips added to all waybar modules

Version 2.9
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.9
--------------------------------------------------------
- New Hyprland Settings App. Can be launched from the App Launcher, the ML4W Welcome App or the new ML4W logo context menu (right click)
- Added sidebar menu. Start with click on ML4W Logo in Waybar. Right click starts the welcome app
- Updated hyprlock screen showing the wallpaper in a circle. hyprlock 3 required
- Waybar Taskbar Module hidden by default. Can be enabled again in the ML4W Settings App
- Hyprpaper is now the default wallpaper engine. swww can be activiated 
- Animations can be disabled in the Dotfiles Settings app
- Animations can be toggled (enabled/disabled) temporarily with SUPER + SHIFT + A
- Keyboard layout is part of the system information module of waybar
- nm-applet can be started from the ML4W Welcome App menu Settings/System
- New diagnosis features checks that essential command are available. Enter ml4w-diagnosis in a terminal or from the ML4W Welcome App

Version 2.8.4
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.8.4
--------------------------------------------------------
- In the ML4W Dotfiles Settings App you can now switch between the wallpaper applications swww or hyprpaper. In case of issues with the default application swww you can select hyprpaper. The wallpaper application can also be disabled but background images for wlogout, hyprlock and rofi will be generated with the selected wallpaper. 
PLEASE NOTE: Logout & Login is required after a change.
- New folder structure for backups: dotfiles-versions/backup holds the latest backup, dotfiles-versions/archive stores archived backups
- Installer can now backup configurations in .config before overwriting by dotfiles
- You can uninstall the ML4W dotfiles with the new uninstaller script starting from the ML4W dotfiles or by executing ~/dotfiles/uninstall.sh
- Using the hypridle.conf suggested by https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/

Version 2.8.3.4
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.8.3.4
--------------------------------------------------------
- Fix swww gray background issue. New command on autostart.conf is 
exec-once = swww init || swww-daemon --format xrgb
- Using blurred version of background image for wlogout
- Add progress bar to dunst notification for wallpaper change and processing

Version 2.8.3.2
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.8.3.2
--------------------------------------------------------
- Replace rofi with rofi-lbonn-wayland to get rofi wayland support
- Several modifications in the ML4W Welcome App
- ML4W Settings App allows to set between 1 and 10 Hyprland workspaces

Version 2.8.3.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.8.3.1
--------------------------------------------------------
- Add compatibility with Hyprland 0.37.1

Version 2.8.3
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.8.3
--------------------------------------------------------
- New ML4W Dotfiles Settings App based on GTK4 with many new customization options
- Hyprlock with blurred version of the current wallpaper as background. Blur strength can be adjusted in the ML4W Dotfiles Settings app
- Hyprlock now showing the current time and username

Version 2.8.2.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.8.2
--------------------------------------------------------
- ML4W Welcome app includes more settings for hypridle. Incl. recommendation from Hyprland Wiki

Version 2.8.2
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.8.2
--------------------------------------------------------
General:
- Force installation of sddm to fix theme issue with sddm-sugar-candy theme. sddm-git doesn't work with themes at the moment
- snapshot.sh script check now for required timeshift and (optional) grub-btrfs packages
- Waybar Bluetooth module now hides automatically if no bluetooth device is detected. Please check that "bluetooth" is not commented out in ~/dotfiles/waybar/modules.json
- Replace hypridle-git with hypridle and hyprlock-git with hyprlock
- Desktop file for ML4W Welcome App to be listed in application launcher + icon

Version 2.8.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.8.1
--------------------------------------------------------
General:
- Swayidle replaced with hypridle (config in dotfiles/hypr/hypridle.conf)
- Swaylock replaced with hyprlock (config in dotfiles/hypr/hyprlock.conf)
- New default wallpaper in Hyprland style
- xarchiver and zip added for thunar
- Rofi border width can be adjusted in dotfiles/.settings/rofi-border.rasi
- emote added to select Emojis (SUPER+.)

ML4W Welcome App: 
- Opens Hyprland systeminfo from the about menu
- Timeshift can be installed from the settings menu
- Terminal for Thunar can be set from the settings menu

Hyprland:
- Bugfix timeshift detection in installupdates.sh 

Qtile:
- Polybar removed from the dotfiles

Version 2.8
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.8
--------------------------------------------------------
Hyprland:
- New Welcome app based on GTK4. Can be launched with the icon on waybar or with the command ml4w
- nwg-look-bin to define a custom GTK Theme
- Updated waybar starter theme
- New waybar idle-inhibator icon
- New waybar theme ml4w-minimal
- New window animation variation animation-moving.conf
- New AI icon to open ChatGPT
- Hyprland installation with hyprland package only. hyprland-git removed from the installer

Version 2.7.2
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.7.2
--------------------------------------------------------
Hyprland:
- New waybar icon to enable/disable swaylock. Left mouse click to toggle swaylock, right mouse click to start swaylock
- Show/Hide idle_inhibitor module (swaylock) in Settings script
- Start of swayidle can be deactivated in the settings script
- New animation variation animation-moving.conf

General:
- Installation script bug fixing
- Alias cleanup added to .bashrc for Arch Linux maintenance
- New Hyprland configuration variation script to roll back to default variations via tty

Version 2.7.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.7.1
--------------------------------------------------------
Hyprland:
- Add optional network-manager applet support. Can be activated in Settings script System/nm-applet
- Show/Hide network module in Settings script
- New Settings for keyboard (incl. natural_scroll for touchpads)
- Add ChatGPT Icon to Waybar. Can be disabled in settings

Qtile:
- Removed polybar from the installation for stability reasons.

Version 2.7
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.7
--------------------------------------------------------
Installation:
- Display Manager SDDM and sugar-candy theme will be installed. 
- Optional display manager disablement possible
- Select between hyprland or hyprland-git
- Arco Linux is now supported. Please choose hyprland-git and reinstall/force the installation of all packages during the installation/update script.

General:
- Adding icons to eza. Adding ls, ll, lt
- New alacritty.toml configuration file

Hyprland:
- New Waybar Module Idle Inhibitor to deactivate the automatic start of swaylock e.g. to watch videos or for online meetings 
- Create own customization of ML4W waybar themes: https://gitlab.com/stephan-raabe/dotfiles/-/tree/main/waybar?ref_type=heads#define-your-own-config-and-stylecss-for-a-ml4w-theme
- Wallpaper selector now with preview thumbnails
- Settings script reworked completely. Implementation of custom modules are now possible. 
- Waybar settings module to edit some ML4W waybar themes settings on the fly
- Waybar with Systray (can be hidden in settings script)
- SDDM settings module to update the SDDM background with current wallpaper
- All image formats are now supported for setting a wallpaper (jpg,jpeg,png,...)

Qtile:
- Removed wayland support due to many limitations. Installation script will rename /usr/share/wayland-sessions/qtile-wayland.session to qtile-wayland.bak to hide in sddm


Version 2.6.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.6.1
--------------------------------------------------------
Installation:
- Add hook.sh to modify the installation files just before the copy procedure into ~/dotfiles. Please check the README.md for more information

Settings Script:
- Added custom.conf which is included at the bottom of the hyprland.conf and can hold you personal configurations. Editable in the section Custom

Hyprland:
- Add foldable module for hardware information
- Add keyboard layout to hardware information
- Add waybar starter theme to waybar

Version 2.6
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.6
--------------------------------------------------------
Installation:
- Script ensures with the start that rsync and gum is installed
- All dialogues implemented with gum to increase usability
- New .dev folder with sync scripts added to sync from dotfiles-version/* to ~/dotfiles (Please check before executing)
- exa replaced with eza (exa not maintained anymore)

Hyprland:
- New settings cli app to change configuration variations on the fly. SUPER+CTRL+S or wheel icon in waybar.
- New variations for decoration and window
- Variations for monitor settings introduced (can be used to define a custom multi-monitor setup. Please see the Hyprland Wiki)
- More keybindings for function keys added
- New ML4W black and white Waybar Theme (+ bottom and blur version)

Known issues Qtile Wayland:
- GTK dark theme not always working
- Screen recording issues with OBS Studio and other applications

Version 2.5.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.5.1
--------------------------------------------------------
Installation:
- Changed from cp to rsync to sync files between folders
- Stability improvements
- New default wallpapers

Version 2.5
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.5
--------------------------------------------------------
Installation:
- Completely reworked script
- Can install Hyprland and/or Qtile
- Backup of existing dotfiles possible
- New optimized download of wallpapers from the repository

General:
- Script folder cleaned up and window manager scripts moved to related wm scripts folder

Hyprland:
- Show key bindings defined in ~/dotfiles/hypr/conf/keybindings.conf rofi menu. Opens with SUPER+CTRL+H or right click on Apps
- Added keybinding to toggle all windows to float and back to tiling (Doesn't work with web apps)
- Add brightness control for FN Brightness keys
- swww loading wallpaper from last session
- New Waybar Theme with blurred background
- Latest Waybar supports now persistent workspaces (set to 5 by default)

Qtile:
- Add wayland support
- New Qtile status bar theme (Qtile status bar is default theme)
- Status bar can be switch on X11 with SUPER + SHIFT + S between Qtile bar and Polybar
- swww/wal loading wallpaper from last session
- Add brightness control for FN Brightness keys

Known issues Qtile Wayland:
- GTK dark theme is not always working
- Screen recording issues with OBS Studio and other applications

Version 2.4
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.4
--------------------------------------------------------
- Now using sddm as Display Manager
- sddm theme sddm-sugar-dark available
- Add Waybar theme switcher (SUPER + CTRL + T)
- Add Waybar theme engine ~/dotfiles/waybar/themes
- Switch to chromium as default browser (SUPER + B)
- Brave is alternative browser (SUPER + CTRL + B)
- Default animations back to standard ~/dotfiles/conf/animations-low.conf due to compatibility reasons. Enhanced animations available in ~/dotfiles/conf/animations-high.conf
- Thunar is default file manager now due to compatibility reasons
- Default icons set to Papirus icon theme
- GTK files updated and cleaned up. gtk-4.0 added (please check the ~/dotfiles/3-dotfile.sh for required symlinks)
- Default cursor set to Bibata Modern Ice
- 1-install.sh checks if base-devel is installed. Required to install and compile yay

Version 2.3
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.3
--------------------------------------------------------
- Add clipboard manager cliphist
- Waybar: Add numbers to workspaces
- Waybar: Add icon for wallpaper selection
- Waybar: Add cliphist icon (click = open, right-click = delete item, middle-click = clear data)
- Screenshots: Add swappy
- Icons: Changed to Kora Icon Theme
- Rofi: New Layout featuring current wallpaper as a background for launcher, cliphist and wallpaper selection
- Update Wallpaper: Add random transition effects
- Hyprland: Exclude configurations files into dedicated files in hypr/conf/ directory
- Hyprland: New window animations (in hypr/conf/)

Version 2.2
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.2
--------------------------------------------------------
- Bugfix: /gtk/gtk-3.0/bookmarks removed from repository
- Bugfix: Added cursor definition to hyprland.conf
- + more smaller fixes

- Login: Move issue into login directory
- Hyprland: Prefer dark theme for gtk3 applications e.g., nautilus
- Hyprland: Add keybinding for filemanager.sh SUPER, CTRL, F to start nautilus (if installed) or thunar
- Installation: Add nautilus package to become new default file manager
- Hyprland install script: Add swayidle to 2-install-hyprland.sh
- Waybar: Add quickstart icon for filemanager.sh
- Waybar: Style improvements
- Dunst: Add white border around notifications
- wlogout: Add new white icons and optimized style with pywal
- Hyprland: Add keybind to passthrough SUPERKEY to Virtual Machine
- Grim: Removed first option in the script for selected window

Version 2.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.1
--------------------------------------------------------
- Several bugfixes
- Updates custom waybar module to check available packages for updates (pacman and aur) plus color theme for number of available packages (waybar/modules.json)
- New installupdates script with Timeshift integration. Ask for name for the Timeshift before starting the updates (scripts/installupdates.sh)
- Waybar: Pywal colors for waybar now with relative link into ./cache/wal/ (waybar/style.css)
