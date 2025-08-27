# Uninstall the ML4W Dotfiles

The uninstallation requires some manual steps. It requires the removal of the dotfiles, the restore of configuration files from the backup and the unstallation of dependencies.

> [!WARNING]
> Uninstalling is a very individual process. There is no guarantee that the following steps will work on all systems.

> [!NOTE]
> The following instructions are work in progress. The Dotfiles Installer will include an uninstall feature in one of the upcoming updates. The way how to unsinstall the dotfiles is still in development. Please share your experiences on GitHub.

## Remove the Hyprland configuration

Logout from the ML4W dotfiles and open another desktop environment (if available on your system) or switch to a tty. 

```sh
cd ~/.config # CD into the config folder
rm -rf hypr # Remove the current symlink to the ML4W hypr config
```
If you're on tty, you can login again to Hyprland now and you should see the default configuration. Please not that you need to open kitty now with SUPER+Q.

## Restore your first backup

Please copy the files from your first backup that you have made with the Dotfiles Installer back to your home and .config folder. Please follow the folder structure from your backup.

You can find the backup folder here:

```sh
cd ~/.var/app/com.ml4w.dotfilesinstaller/data/backup
cd com.ml4w.dotfiles # for rolling release
cd com.ml4w.dotfiles.stable # for stable release
```
## Delete symlinks (optional)

Remove all symlinks from your Home folder and .config folder targeting to the .mydotfiles folder.

```sh
cd ~/.config
rm -rf waybar # example
```

## Remove the dotfiles folder (optional)

Open the following folder and remove the dotfiles:

```sh
cd ~/.mydotfiles
rm -rf com.ml4w.dotfiles # for rolling release
rm -rf com.ml4w.dotfiles.stable # for stable release
```
## Uninstall dependencies (optional)

You can uninstall <a href="/dotfiles/getting-started/dependencies">dependencies</a> that you don't need anymore. 

> [!WARNING]
> Please make sure that you don't uninstall packages that are required by your system.

## Uninstall ML4W Apps

Please run the following commands to uninstall the ML4W Flatpak Apps from your system:

```sh
flatpak uninstall com.ml4w.welcome
flatpak uninstall com.ml4w.settings
flatpak uninstall com.ml4w.calendar
flatpak uninstall com.ml4w.sidebar
flatpak uninstall com.ml4w.hyprlandsettings

```
