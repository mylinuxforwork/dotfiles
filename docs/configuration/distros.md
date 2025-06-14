> [!CAUTION]
> The following instructions are barely tested and in BETA. But you can give it a try and please report back your experiences.

The ML4W Dotfiles are shipped with a comprehensive Hyprland configuration. Some scripts (check for updates) are implemented for Arch only but the general configurations could also work on other distributions.

Please make sure that the following packages are installed on your system:
* Required packages: https://github.com/mylinuxforwork/dotfiles/tree/main/share/packages

Follow the steps to install the dotfiles:

```sh
# 1.) Change into your Downloads folder (create the folder if not available)
cd ~/Downloads

# 2.) Clone the dotfiles repository into the Downloads folder
git clone --depth=1 https://github.com/mylinuxforwork/dotfiles.git

# 3.) Change your keyboard layout
cd dotfiles/share/dotfiles/.config/hypr/conf/
vim keyboard.conf

# 4.) Change into the dotfiles folder
cd dotfiles/share/dotfiles/.config

# 5.) Copy the dotfiles to your home directory
cp -r . ~/.config

```
Some system related scripts will not work. But feel free to share your experiences.

