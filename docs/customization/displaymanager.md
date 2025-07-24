# Display Manager

This tutorial will guide you through installing a display manager like SDDM and switching between different display managers like SDDM and GDM on a Linux system. Display managers provide a graphical login screen and manage user sessions.

> [!NOTE]
> The ML4W Dotfiles does not include a Display Manager configuration because of the prevention to manipulate a sensitive system resource like display managers directly.

First update your package list before installing the display manager.

::: code-group

```sh [Arch]
sudo pacman -Syu
```

```sh [Fedora]
sudo dnf update
```

```sh [openSuze]
sudo zypper update
```
:::

## SDDM 

### Install SDDM for your distribution:

::: code-group

```sh [Arch]
sudo pacman -S sddm
```

```sh [Fedora]
sudo dnf install sddm
```

```sh [openSuze]
sudo zypper install sddm
```
:::


### Enable SDDM (if not automatically enabled)

During installation, some distributions might prompt you to choose the default display manager. If not, or if you want to explicitly enable it, you can do so.

For systems using systemd (most modern distributions):

```sh 
sudo systemctl enable sddm
```

If you were previously using another display manager (like GDM) and it was enabled, enabling SDDM will usually disable the old one automatically. However, if you want to be sure, you can explicitly disable the old one (e.g., GDM):
Bash

```sh 
sudo systemctl disable gdm # Only if GDM was previously enabled
```
### Install SDDM Themes

The installation of an SDDM Theme depends on the theme developer. There are many great SDDM themes available on Gnome Look: https://www.gnome-look.org/browse?cat=101&ord=top

Installing a custom SDDM theme generally involves downloading the theme, extracting it, placing it in the correct directory, and then configuring SDDM to use it.


#### Step 1: Download the Theme

1. Open your web browser and go to the theme page: https://www.gnome-look.org/p/1312658
2. Navigate to the "Files" tab on the theme page.
3. Download the latest version of the theme. It will usually be a .tar.gz or .zip file. For the "Nordic" SDDM theme, look for a file like Nordic-SDDM.tar.gz.

> [!TIP]
> Note where the file is downloaded (e.g., your Downloads directory).

#### Step 2: Extract the Theme

1. Open a terminal.
2. Navigate to the directory where you downloaded the theme. For example, if it's in your Downloads folder:

```sh 
cd ~/Downloads
```
3. Extract the contents of the downloaded archive.

If it's a .tar.gz file:

```sh 
tar -xvf Nordic-SDDM.tar.gz
```

If it's a .zip file:

```sh 
unzip Nordic-SDDM.zip
```
This will create a new directory (e.g., Nordic-SDDM or Nordic) containing the theme files.

#### Step 3: Move the Theme to the SDDM Themes Directory

SDDM themes are typically stored in /usr/share/sddm/themes/. You'll need sudo privileges to move files into this system directory.

Move the extracted theme directory into the SDDM themes folder. Replace Nordic-SDDM with the actual name of the directory that was created after extraction.

```sh 
sudo mv Nordic-SDDM /usr/share/sddm/themes/
```
> [!NOTE]
> Ensure you move the entire theme folder, not just its contents, into the /usr/share/sddm/themes/ directory.

#### Step 4: Configure SDDM to Use the New Theme

Now, you need to tell SDDM to use your newly installed theme. This is done by editing the SDDM configuration file.

Open the SDDM configuration file for editing. The primary configuration file is usually located at /etc/sddm.conf or /etc/sddm.conf.d/sddm.conf. If /etc/sddm.conf doesn't exist, check for a file like 10-theme.conf within /etc/sddm.conf.d/. You might need to create a new .conf file in /etc/sddm.conf.d/ if one isn't present for custom configurations.

```sh 
sudo vim /etc/sddm.conf
```
(You can replace vim with your preferred text editor like vim or gedit).

1. Locate the [Theme] section. If it doesn't exist, add it.
2. Set the Current= option to the name of your new theme directory. This name should exactly match the directory you moved into /usr/share/sddm/themes/.

The section should look something like this:

```sh 
[Theme]
Current=Nordic-SDDM
```
(Replace Nordic-SDDM with the actual name of the theme directory if it's different, e.g., Nordic).

3. Save the file and exit the editor.

Alternative Configuration (if /etc/sddm.conf doesn't exist or is empty):
You might need to create a new configuration file in /etc/sddm.conf.d/ if your system uses this structure for modular configurations.

```sh 
sudo vim /etc/sddm.conf.d/custom-theme.conf
```
Then, add the following content:

```sh 
[Theme]
Current=Nordic-SDDM
```

4. Save and exit the file.

#### Step 5: Apply the New Theme

For the changes to take effect, you need to restart the SDDM service.

Restart the SDDM service:

```sh 
sudo systemctl restart sddm
```
> [!CAUTION]
> This command will immediately take you back to the login screen. Make sure you have saved any open work before executing it.

After restarting, you should be greeted by the new SDDM theme. If you encounter any issues, double-check the theme directory name and the Current= entry in the configuration file for typos.

## Switching between display managers

Most Linux distributions provide a convenient way to switch between installed display managers. We'll assume you have SDDM installed, which is common if you use the GNOME desktop environment.

Disable SDDM: 

```sh 
sudo systemctl disable sddm
```

Enable GDM:

```sh 
sudo systemctl enable gdm # or gdm3
```

Stop SDDM and start GDM immediately (optional, or just reboot):

```sh 
sudo systemctl stop sddm
sudo systemctl start gdm # or gdm3
```
Reboot your system:

```sh 
sudo reboot
```
