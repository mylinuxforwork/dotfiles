# Migration to the new Dotfiles Installer

The ML4W Dotfiles for Hyprland will be installed with the Dotfiles Installer. You can migrate your legacy installtion to the new Dotfiles Installer setup by following the next steps.

::: info
Version 0.9.1 of the Dotfiles Installer or higher is required
:::

### 1. Install the Dotfiles Installer

Click on the badge below to install the Dotfiles Installer from Flathub.

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

### 2. Start the Dotfiles Installer

Open the app launcher to start the app or run 

```sh
flatpak run com.ml4w.dotfilesinstaller
```
### 3. Load the .dotinst file and download the latest version

Copy the following url into the Dotfiles Installer and click on Load.

#### Stable Release

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst
```
#### Rolling Release

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```
Then click on Download to download the latest version.

Run the setup script to install the latest dependencies.

::: info
You can probably skip the setup step when you have already installed the latest version before.
:::

### 4. Migrate the dotfiles

After downloading the dotfiles, click on the folder menu and select `Open Prepared Folder`. Replace all files in the `prepared` folder with the files and folders of `~/dotfiles`.

![image](/migrate.jpg)

Then click on `Migrate from Prepared Folder`.

### 5. Protect your configuration

In case that you have custom adaptations of the dotfiles, please select the files and folder that you want to protect from overwriting during the installation or update. Your selection will be saved for upcoming updates. 

### 6. Install the Dotfiles

You can install and activate the dotfiles directly. 

### 7. Update the Dotfiles

You can always update the Dotfiles from the Dotfiles Installer Start Screen to the latest version.
