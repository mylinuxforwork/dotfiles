Start the ML4W Welcome App. You will see a notification when an update is available. You can start the update or re-installation of the ML4W Dotfiles at any time.

> [!NOTE]
> you can create a backup of your existing configuration with the backup feature of the install script. It's recommended to remove the folder ~/dotfiles only after creating a backup. 

## Update from the Welcome App

You can start the update directly from the ML4W Welcome App. Select Update/Reinstall your ML4W Dotfiles.

![image](https://github.com/user-attachments/assets/86bb4c17-e440-4510-83f4-57535c237d5b)


## Update with your AUR Helper

You can use your AUR Helper to update the packages on your system.

```sh
yay
```
After the installation, you can start the update with the command

```sh
ml4w-hyprland-setup
```

The script will ask for an installation folder. Please enter a folder name without spaces. The script will create the folder for you and continue with the installation.

You can also install multiple versions of the ML4W Dotfiles in parallel in different folders. You can switch between the folders with the included activation script (only works with 2.9.5 or higher). 

## Update from previous versions (older than 2.9.6)

The suggested way to update from a version older than 2.9.6 is the installation as AUR with your preferred AUR Helper.

```sh
# Download the latest version (main release)
yay -S ml4w-hyprland

# Start the setup
ml4w-hyprland-setup
```

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
