![image](/install.png)

## Before you start

**PLEASE BACKUP YOUR EXISTING .config FOLDER WITH YOUR DOTFILES BEFORE STARTING THE SCRIPTS FOR INITIAL INSTALLTION.**

The installation script will create a backups from configurations of your .config folder that will be overwritten from the installation procedure and previous ML4W Dotfiles installation.

If possible, please create a snapshot of your current system if snapper or Timeshift is installed and available.

You can decide between the following packages:
- ML4W Dotfiles Main Release (latest tagged release)
- ML4W Dotfiles Rolling Release (main branch including the latest commits)

YouTube Video https://youtu.be/siy2vL94yd0

## Recommendation

I recommend to install a base Hyprland system before installing the ML4W Hyprland Dotfiles. Then you have a stable starting point and can test Hyprland on your system before. Hyprland is complex, under ongoing development and requires additional components. 

On Arch Linux you can also install the Hyprland Desktop Profile first.

You can find the Hyprland Installation instructions here: https://wiki.hyprland.org/Getting-Started/Installation/

## Distro (based)

Just copy the following command into your terminal and execute:

::: code-group

```sh [<i class="devicon-archlinux-plain"></i> Arch]
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh)
```

```sh [Aur Stable]
yay -S ml4w-hyprland
ml4w-hyprland-setup
```

```sh [Aur Rolling]
yay -S ml4w-hyprland-git
ml4w-hyprland-setup
```

```sh [<i class="devicon-fedora-plain"></i> Fedora]
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-fedora.sh)
```

:::

### Installation folder

The script will ask for an installation folder. Please enter a folder name without spaces. The script will create the folder for you and continue with the installation.

You can also install multiple versions of the ML4W Dotfiles in parallel in different folders. You can switch between the folders with the included activation script (only works with 2.9.5 or higher). 

## Installation with GIT (Rolling Release)

You can install the dotfiles by cloning the latest version (rolling release):

```sh
# 1.) Change into your Downloads folder (create the folder if not available)
cd ~/Downloads

# 2.) Clone the dotfiles repository into the Downloads folder
git clone --depth=1 https://github.com/mylinuxforwork/dotfiles.git

# 3.) Change into the dotfiles/bin folder
cd dotfiles/bin

# 4.) Start the installation
./ml4w-hyprland-setup
```

> [!NOTE]
> Not all features will work, when you install the dotfiles from GIT.

