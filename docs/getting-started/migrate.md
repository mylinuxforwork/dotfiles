# Migration to the new Dotfiles Installer

The ML4W Dotfiles for Hyprland will be installed with the Dotfiles Installer. You can migrate your legacy installtion to the new Dotfiles Installer setup by following the next steps.

## 1. Install the Dotfiles Installer

Click on the badge below to install the Dotfiles Installer from Flathub.

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

> [!NOTE]
> Version 0.9.1 or higher is required

## 2. Start the Dotfiles Installer

Open the app launcher to start the app or run 

```sh
flatpak run com.ml4w.dotfilesinstaller
```
## 3. Load the .dotinst file and download the latest version

Copy the following url into the Dotfiles Installer and click on Load.

#### Stable Release 2.9.8.7 (Requires Dotfiles Installer 0.8.9 or newer)

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst
```
#### Rolling Release

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```
Then click on Download to download the latest version.

Run the setup script to install the latest dependencies.

> [!NOTE]
> You can probably skip the setup step when you have already installed the latest version before.

## 4. Create the target folder and migrate your files

Then replace all files in the `prepared` folder.

Then click on `Next`.


## Protect your configuration

## Install your dotfiles

Click on activate

