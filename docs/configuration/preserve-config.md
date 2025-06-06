> [!NOTE]
>The installation script will prepare the all files in a folder ~/.ml4w-hyprland/[version] before starting the copy of the files into the final destination, e.g., ~/dotfiles/. You can modify the prepared dotfiles with a hook script to protect your personal adjustments and you can install additional packages with a post script.

## Protect folder in .config with PROTECTED

You can protect any configuration folder in .config by adding an empty file with filename PROTECTED. The installation script will detect the file and skip the update and overwrite of any files of the configuration.

## Protecting your own dotfiles adjustments with hook.sh

> [!NOTE]
> If you want to create the files manually copy the prepared templates from here https://github.com/mylinuxforwork/dotfiles/tree/main/share/templates

> If you want to modify the installation files just before the copy procedure starts, you can create a file hook.sh in the folder ~/.ml4w-hyprland/

With this hook script you can protect your own customization of files in ~/dotfiles from getting overwritten by an update of new version of the ML4W Dotfiles.

The following information describes as an example how you can protect your customization of the .bashrc and nvim folder in ~/dotfiles.

After installing the ML4W Dotfiles you will find the file hook.tpl in ~/.ml4w-hyprland

Rename the file and make it executable:

```sh
mv hook.tpl hook.sh
chmod +x hook.sh
```

Open the file in your preferred editor.

```sh
#!/bin/bash
# ------------------------------------------------------
# Don't edit this section
# Include scripts.sh with helper functions
source library/scripts.sh
# ------------------------------------------------------

# Show Current version
echo ":: Running hook for ML4W Dotfiles $version"

# If you made adjustments in the installation folder e.g., ~/dotfiles folder 
# you can protect the files and folders from being overwritten by updates.

_protect .config/nvim
_protect .bashrc

# You can add more command to get executed before the prepared dotfiles 
# will be copied to the target folder ~/dotfiles

```

In this case you protect the nvim folder and the .bashrc file. 

> The _protect function is a helper function shipped with the ML4W Dotfiles.

Next time you run the ML4W installer the script will detect the existing hook.sh and will offer to execute it.

You can of course add more bash commands to this script if needed.

## Execute commands after the installation with post.sh

The following information describes as an example how you can install kitty after the installation with the post.sh script.

After installing the ML4W Dotfiles you will find the file post.tpl in ~/.ml4w-hyprland

Rename the file and make it executable:

```sh
mv post.tpl post.sh
chmod +x post.sh
```

Open the file in your preferred editor.

```sh
#!/bin/bash
# ------------------------------------------------------
# Don't edit this section
# Include scripts.sh with helper functions
source library/scripts.sh
# ------------------------------------------------------

# Show Current version
echo ":: Running hook for ML4W Dotfiles $version"

# Install additional packages
_installPackagesPacman "kitty"
_installPackagesYay "wlogout"
_installPackagesFlatpak "com.spotify.Client"

# Remove installed packages
# sudo pacman -R alacritty
```

The script will check if kitty and wlogout is already installed and install them if not.

> The _installPackagesPacman and _installPackagesYay functions are a helper function shipped with the ML4W Dotfiles.

You can also uninstall packages if needed.

Next time you run the ML4W installer the script will detect the existing post.sh and will offer to execute it at last step of the installation.

## Helper Script

The above used functions are shipped with the ML4W Dotfiles and are stored in ~/.ml4w-hyprland/library/scripts.sh

> This file will be updated with every new version of the Dotfiles and will provide more helper functions in the future.

