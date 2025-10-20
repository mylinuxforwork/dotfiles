Version 2.9.9.3
--------------------------------------------------------
- New Default icons Colloid
- Improved Waybar modern theme and new minimal version
- Reduced border size to 2px
- Border size of NWG Dock Hyprland can be modified in ~/.config/ml4w/settings/dock-border.css
- Walker can be optionally activated as system-wide launcher (except screenshot). https://mylinuxforwork.github.io/dotfiles/configuration/walker
- New default wallpaper
- Arch setup script checks for installed AUR helper (yay or paru)

Version 2.9.9.2
--------------------------------------------------------
- New ML4W Logo
- Compatible with Hyprland 0.51.x
- New default wallpaper
- New swaync layout with dark or light theme support

Version 2.9.9.1
--------------------------------------------------------
- Full dark and light theme support. Change preferred theme in nw-look. A listener script will reload waybar and nwg-dock-hyprland when the file ~/.config/gtk-4.0/settings.ini will be changed.
- Waybar Theme ML4W Modern Dark and Light consolidated into ML4W Modern Theme
- Wallust removed as color generator. Not needed anymore for kitty colors.
- Fish configuration added and shell selection script extended.
- New default wallpaper
- New sidepad feature to move windows to the right side of the screen. https://mylinuxforwork.github.io/dotfiles/usage/sidepad
- New focus script: Select window and switch to workspace with CTRL + Tab
- New Sidebar App layout with Light/Dark theme toggle button

Version 2.9.9
--------------------------------------------------------
- Legacy installer removed and folders restructured 
- Font Awesome 7 support added
- Optimized setup script to reduce the installation time of dependencies
- Waybar with blurred background as default (powered by Hyprland). Can be switched off in the Dotfiles Settings app/Appearance/Decoration Variations -> no blur
- ML4W blur theme removed. See above to toggle blur
- Add Display Zoom: Zoom in with SUPER+SHIFT+Mousewheel up, Zoom out with SUPER+SHIFT+Mousewheel down, Reset Zoom with SUPER+SHIFT+Z
- Link to ML4W Wallpaper Bank added to Welcome App main menu
- Specific variations for game mode added to start Hyprland in game mode: Settings app, Appearance: Decoration: gamemode.conf, Window: gamemode.conf, Animation: disabled.conf

Version 2.9.8.8
--------------------------------------------------------
- Optimized setup scripts for Arch, Fedora and openSuse
- eza, matugen and wallust now shipped with the dotfiles to speedup installation (cargo not needed anymore)

Version 2.9.8.7
--------------------------------------------------------
- New Wiki launched under https://mylinuxforwork.github.io/dotfiles/
- Configuration prepared for Dotfiles Installer https://mylinuxforwork.github.io/dotfiles-installer/ with setup scripts for Arch Linux, Fedora and openSuse Tumbleweed
- All ML4W apps are following now the GTK4 Theme. Please make sure that the ml4w-repo is added to your system and all ml4w flatpaks are installed system wide, not user
- Improved waybar modern theme
- Installation of Sequoia Theme removed from the installation script 
- You can restore the standard SDDM Theme and install your custom display manager individually.
- How to install Sequoia Theme guide on ML4W Dotfiles Wiki https://github.com/mylinuxforwork/dotfiles/wiki/Customize-sddm
- Wallust for terminal color generation
- New immediate screenshot keybindings: `SUPER+ALT+F` for fullscreen, `SUPER+ALT+S` for area screenshot
- AUR packages of ML4W Dotfiles removed. Please use the install script from https://mylinuxforwork.github.io/dotfiles/
- Default Wallpaper folder moved to `~/.config/ml4w/wallpapers` and new default wallpaper

Version 2.9.8.6
--------------------------------------------------------
- Matugen color theme improvements
- Wallust for terminal color generation

Version 2.9.8.5
--------------------------------------------------------
- Pywal has been replaced with matugen
- All color themes improved for matugen
- New kitty color theme based on matugen
- Colored, mixed and bottom waybar themes removed
- New default wallpaper
- eza will be installed with cargo

Version 2.9.8.4
--------------------------------------------------------
- New app icons for ML4W apps
- Optimizations for app positions
- Hypridle must be configured in ~/.config/hypr/hypridle.conf due to compatibility reasons (removed from ML4W Settings App)

Version 2.9.8.3
--------------------------------------------------------
- Compatible with Hyprland 0.48
- New keybinding: Switch between selected windows with ALT + Tab
- New default animation and animation-end4.conf (credits to end4)
- Add cursor trail to kitty (Can be disabled in .config/ml4w/settings/kitty-cursor-trail.conf)
- Window Rules compatible with Hyprland 0.48.x
- New Default Wallpaper

Version 2.9.8.2
--------------------------------------------------------
- ML4W Hyprland Settings App converted to Flatpak
- Add uwsm for Arch Linux distributions
- Now with nwg-displays support (https://github.com/mylinuxforwork/dotfiles/wiki/Monitor-Configuration)
- Tiled Windows can be swapped now with SUPER+ALT+Arrowkey
- Added floating class for Ghostty ml4w.dotfiles.floating (--class=ml4w.dotfiles.floating)
- Add power profiles daemon module to waybar

Version 2.9.8.1
--------------------------------------------------------
- Bug fixes
- Opacity for the light version of the dock optimized

Version 2.9.8
--------------------------------------------------------
- All ML4W Apps (except Hyprland Settings for now) are now flatpak apps.
- New ML4W Sidebar App gives quick access to selected configurations. It replaces the ags sidebar.
- All apps are supporting now light and dark theme. Change the color theme in nwg-look for GTK and/or QT6.
- SwayNC added as new notification center with additional features.
- Installation of kitty, nvim, .bashrc and .zshrc configurations require user confirmation for overwriting.
- Walcord support in wallpaper.sh script

Version 2.9.7.4
--------------------------------------------------------
- New default wallpaper
- New default waybar theme ML4W Modern
- Improved sidebar layout including power functions
- Kitty now with JetBrainsMono font
- Workspaces Variations added to ML4W Settings App

Version 2.9.7.3
--------------------------------------------------------
- Disabled wallpaper cache by default due to stability reasons. Can be enabled in the settings app again
- Performance improvements in wallpaper script
- New default wallpaper
- Add new oh-my-posh prompt to bash

Version 2.9.7.2
--------------------------------------------------------
- Wallpaper issues fixed
  Arch: Installer asked to rebuild waypaper to be compatible with Python 3.13
  You can also run yay -S --answerclean All --noconfirm --rebuildall waypaper python-screeninfo python-imageio
- All settings moved from waybar into sidebar due to stability reasons

Version 2.9.7.1
--------------------------------------------------------
- New horizontal wlogout layout
- Hibernate option removed. Requires individual system setup
- Timezone for waybar clock can be set individually in the ML4W Settings App
- Installation of nwg-hyprland-dock via installation options
- nwg-hyprland-dock can be toggled in settings app
- New Waybar Theme ml4w-modern (+ versions)
- New Rofi Layout for App Launcher
- New Terminal prompt theme

Version 2.9.7.0
--------------------------------------------------------
- Fedora support added. Please see the installation instruction on https://github.com/mylinuxforwork/dotfiles/wiki
- One command installation added for Fedora and Arch based distributions
- New default wallpaper added

Version 2.9.6.7
--------------------------------------------------------
- Add geenral ags v2 support to sidebar and calendar widget. More feature to come.

Version 2.9.6.6
--------------------------------------------------------
- Compatible with Hyprland 0.45.0. Replaced legacy variables for drop shadows with new ones in hypr/conf/decorations
- Zen Browser added to Installation Options browsers
- Suggested additional default apps added to section others in Installation Options script

Version 2.9.6.5
--------------------------------------------------------
- New SDDM login theme sequoia. Theme can be customized by renaming the file .config/ml4w/settings/sddm/theme.tpl to theme.conf
- NVIDIA driver installation script added. Start the installation with ml4w-hyprland-setup -m nvidia

Version 2.9.6.4
--------------------------------------------------------
- Kitty is the new default terminal (Replace alacritty with kitty in the ML4W Settings App/Default terminal)
- Kitty is supporting pywal colors
- New installation options script to install additional packages. Can be opened from the ML4W Welcome App.
- Added pywalfox support to color Firefox based on wallpaper colors
- Fixed eza icons on zsh terminal
- Subfolders in .config can be protected with an empty file PROTECTED
- OhMyPosh prompt replaces Starship prompt
- Networkmanager applet can be toggled with right click on waybar network module
- Three more blue light screen shaders with different intensities

Version 2.9.6.3
--------------------------------------------------------
- Updated ags sidebar layout
- Calendar widget shows always current date when opening
- Wallpaper, Effects and waybar theme switcher button moved into sidebar
- Settings group in waybar can be hidden in the ML4W Settings App
- Wallpaper cache covering also blurred images
- Added "Open in terminal" feature to Nautilus
- New default wallpaper.

Version 2.9.6.2
--------------------------------------------------------
- App Menu icon can be hidden from the ML4W Settings App
- Setup script optimize the keybindings if french keyboard layout (fr) is selected
- Add full waypaper features with waypaper 2.3. Brings back swww support including animations.
- ML4W apps will be now installed into the linux file system

Version 2.9.6.1
--------------------------------------------------------
- AGS calendar widget moved from sidebar into own widget. Opens with click on clock module in waybar
- settings.json removed and moved all settings into dedicated files in ~/.config/ml4w/settings/
- New standard animation configuration
- Quicklinks Module can be hidden from the ML4W Settings App

Version 2.9.6
--------------------------------------------------------
- ML4W Dotfiles now available as AUR: ml4w-hyprland (latest release) and ml4w-hyprland-git (rolling release with latest commits)
- ~/dotfiles-versions folder renamed to ~/.ml4w-hyprland
- Switch between bash and zsh from the ML4W Welcome App (Settings -> System -> Change shell)
- New modular and extendable bashrc structure in ~/.config/bashrc
- .bashrc_custom moved into folder ~/.config/bashrc/bashrc_custom
- New modular and extendable zshrc structure in ~/.config/zshrc
- Gnome Calculator (SUPER+CTRL+C) and Emoji Picker Smile (SUPER+CTRL+C) added (Can be changed in the ML4W Dotfiles Settings App)
- Add Swapsplit keybinding: SUPER + K
- Folder and filename format for screenshots can be defined in screenshot-filename.sh and screenshot-folder.sh in ~/.config/ml4w/settings/
- The installer detects the AUR Helper in use. You can use paru instead of yay by installing paru and add paru to ~/.config/ml4w/settings/aur.sh

Version 2.9.5
--------------------------------------------------------
- The folder name and location of the dotfiles folder can be now individual defined during the update and installation.
- You can copy the dotfiles folder to another location and rename it. The folder can the be activated with the ML4W Welcome App.
- The installation and update steps can be fully automated with the new automation.sh script.
- Backlight module to waybar for laptop users added.
- Post Installation Script added. Will be executed once after the first installation to install needed packages like xdg-desktop-portal-gtk
- New wallpaper effects added. Right click on waybar wallpaper icon

Version 2.9.4
https://github.com/mylinuxforwork/dotfiles/milestone/1?closed=1
--------------------------------------------------------
- EWW replaced with AGS. New ML4W Sidebar based on AGS
- New hook.sh and post.sh installation scripts. https://github.com/mylinuxforwork/dotfiles/wiki/Hook-and-Post-Installation-Scripts
- Add Flatpak installation option to the installation script https://github.com/mylinuxforwork/dotfiles/issues/43
- Position of dunst can be changed in the ML4W Dotfiles App
- Screenshot script based on grimblast.
- New screenshot editor pinta added to package list. Editor can be changed in the ML4W Dotfiles app and in dotfiles/.settings/screenshot-editor.sh

Version 2.9.3
https://github.com/mylinuxforwork/dotfiles/blob/main/CHANGELOG.md
--------------------------------------------------------
- ML4W .bashrc can be extended by adding a file .bashrc_custom in your home directory to create custom aliases and more
- Adding Missioncontrol as new systeminfo app
- New animation variation animations-dynamic.conf. Requires some resources and is therefore not recommended for installations on virtual machines or slower systems. Can be selected in the ML4W Dotfiles Settings app.
- New repository folder structure. All configuration dotfiles are now separated from the installer in the folder dotfiles

Version 2.9.2.1
https://gitlab.com/stephan-raabe/dotfiles/-/releases/2.9.2.1
--------------------------------------------------------
- ML4W Sidebar performance optimized. Bug fixed of memory script.
- Alternatively to the ML4W Welcome App you can start the Update script from a terminal with the command ml4w-update (ML4W .bashrc must be used)
- Switched from Chromium to Firefox as default browser. Firefox performs much better on Wayland. Update script will offer the installation of Firefox in case that another browser is currently activated
- New key binding to move all windows to another workspace with SUPER+CTRL+"workspace"
- New key binding to start the automatic wallpaper change script with SUPER+ALT+W. The delay time can be set in ~/dotfiles/.settings/wallpaper-automation.sh https://gitlab.com/stephan-raabe/dotfiles/-/wikis/Home/Wallpapers#wallpaper-automation
- Screenshader will be deactivated during screenshot creation

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
- Hyprpaper is now the default wallpaper engine. swww can be activated
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
