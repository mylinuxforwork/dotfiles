# ML4W OS Dotfiles

This repository contains dotfiles for an advanced configuration of Hyprland, a dynamic tiling window manager, primarily targeted at Arch Linux-based distributions. The project aims to provide a full-featured desktop environment with adaptive material color themes based on the selected wallpaper, and a comprehensive selection of applications.

## Directory Overview

The project is structured as follows:

*   `.github/`: Contains GitHub-related configurations, including issue and pull request templates.
*   `dev/`: Development-related files, including a protected text file and a sync script.
*   `docs/`: Project documentation, including an `index.html` and a 404 page. It's just a redirect to the new location of the documentation on https://ml4w.com/os/
*   `dotfiles/`: The core of the repository, containing configuration files for various applications and system components. This includes:
    *   Shell configurations (`.bashrc`, `.zshrc`)
    *   GTK themes (`.gtkrc-2.0`, `gtk-3.0/`, `gtk-4.0/`)
    *   Hyprland configurations (`.config/hypr/`) which are highly modularized, sourcing many smaller configuration files.
    *   Configurations for various applications like `kitty`, `nvim`, `rofi`, `waybar`, `wlogout`, etc.
*   `setup/`: Contains scripts for setting up the system and installing dependencies.
    *   `setup.sh`: The main installation script that detects the distribution and calls the appropriate setup script (e.g., `setup-arch.sh`, `setup-fedora.sh`, `setup-opensuse.sh`).
    *   `_lib.sh`: A library of utility functions used by the setup scripts (e.g., for checking command existence, displaying headers).
    *   `pkgs.sh`: Defines lists of packages to be installed (general, hyprland-specific, applications, and tools).
    *   Other scripts for installing cursors, fonts, icons, flatpaks, and specific ML4W apps.

## Key Files

*   `README.md`: Provides a general overview, installation instructions, and credits.
*   `hyprland-dotfiles-stable.dotinst`, `hyprland-dotfiles.dotinst`: These files are used by the ML4W Dotfiles Installer for deploying the configurations.
*   `setup/setup.sh`: The primary script for initial environment setup and package installation.
*   `dotfiles/.config/hypr/hyprland.conf`: The main Hyprland configuration file, which sources a modular set of other configuration files to manage different aspects of the desktop environment.
*   `dotfiles/.zshrc`: The Zsh shell configuration, which also uses a modular approach to load settings and allows for user customizations.

## Usage

This project is intended to be used as a comprehensive dotfiles solution for Hyprland on Arch-based systems.

**Installation:**

1.  **Using the Dotfiles Installer:** The recommended method is to use the ML4W Dotfiles Installer. Users can copy the provided URLs (`hyprland-dotfiles-stable.dotinst` or `hyprland-dotfiles.dotinst`) into the installer.
2.  **Manual Installation via Setup Scripts:**
    *   The `setup/setup.sh` script can be executed to automatically detect the user's distribution (Arch, Fedora, openSuse) and install the necessary packages and dependencies.
    *   For other distributions, users are advised to install dependencies manually, referring to the `setup/pkgs.sh` for a list of required packages.

The configuration files in ./dotfiles will be installed through the Dotfiles Installer into the folder ~/.mydotfiles/com.ml4w.dotfiles Symlinks will be created to target the users home directory and .config folder.

**Customization:**

The dotfiles are designed for modularity and customization. Users can create custom configurations by modifying specific files or creating override files as indicated in the comments within configuration files (e.g., `hyprland.conf` and `.zshrc` explicitly mention locations for user-specific settings).
