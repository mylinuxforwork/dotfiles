# Update

Start the ML4W Welcome App. You will see a notification when an update is available. You can start the update or re-installation of the ML4W Dotfiles at any time.

> [!NOTE]
> You can create a backup of your existing configuration with the backup feature of the install script. It's recommended to remove the folder ~/dotfiles only after creating a backup. 

## Update from the Welcome App

You can start the update directly from the ML4W Welcome App. Select Update/Reinstall your ML4W Dotfiles.

![image](/update.png)

## Update with the Dotfiles Installer

If you have installed the Dotfiles with the Dotfiles Installer, just open the Dotfiles Installer and click on the Refresh Icon to start the update.

## Update with GIT

Please follow the steps to update from earlier dotfiles versions to 2.8.3

```sh
# 1.) Remove existing downloaded dotfiles
rm -rf ~/Downloads/dotfiles

# 2.) Change into your Downloads folder
cd ~/Downloads

# 3.) Clone the dotfiles repository into the Downloads folder
git clone --depth=1 https://github.com/mylinuxforwork/dotfiles.git

# 4.) Change into the dotfiles folder
cd dotfiles/bin

# 5.) Start the installation
./ml4w-hyprland-setup

```
