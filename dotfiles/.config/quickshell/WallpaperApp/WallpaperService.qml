pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Shared state for the wallpaper grid (WallpaperWindow) and the carousel
// (WallpaperCarousel): the wallpaper folder, the current wallpaper and the
// call that applies a wallpaper.
Singleton {
    id: root

    property string defaultWallpaperFolder: Quickshell.env("HOME") + "/.config/ml4w/wallpapers"
    property string wallpaperSettingFile: Quickshell.env("HOME") + "/.config/ml4w/settings/wallpaper-folder"
    property string currentWallpaperFile: Quickshell.env("HOME") + "/.cache/ml4w/hyprland-dotfiles/current_wallpaper"
    property string wallpaperScript: Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-wallpaper"

    // Start as default in case file does not exist
    property string wallpaperFolder: defaultWallpaperFolder

    // Raw text of the folder setting, as shown in the advanced options
    property string wallpaperFolderSetting: ""

    // Path of the wallpaper last applied with theming. May point to an
    // effect copy in the cache ("<effect>-<name>"), so match on file name.
    property string currentWallpaper: ""

    FileView {
        id: wallpaperDirSettingFileHandler
        path: Qt.url(root.wallpaperSettingFile)
        blockLoading: true
        watchChanges: true
        onFileChanged: {
            this.reload();
            const settingValue = this.text().trim()
            console.log("Wallpaper directory setting changed on disk; attempting to load directory \"" + settingValue + "\"")
            root.updateWallpaperFolder(settingValue)
        }
        onLoaded: {
            const settingValue = this.text().trim()
            console.log("Loading wallpaper directory \"" + settingValue + "\"")
            root.updateWallpaperFolder(settingValue)
        }
        onSaved: {
            const settingValue = this.text().trim()
            console.log("Wallpaper directory setting saved successfully; reloading from directory \"" + settingValue + "\"")
            root.updateWallpaperFolder(settingValue)
        }
    }

    FileView {
        id: currentWallpaperFileHandler
        path: Qt.url(root.currentWallpaperFile)
        watchChanges: true
        printErrors: false
        onFileChanged: this.reload()
        onLoaded: root.currentWallpaper = this.text().trim()
    }

    function updateWallpaperFolder(dirString): void {
        root.wallpaperFolderSetting = dirString
        root.wallpaperFolder = dirString.replace(/~|\$HOME/g, Quickshell.env("HOME"))
    }

    function setWallpaperFolder(dirString): void {
        console.log("Updating wallpaper directory to \"" + dirString + "\"")
        wallpaperDirSettingFileHandler.setText(dirString)
    }

    // Blank the folder and set it back so every FolderListModel rescans it
    function reloadImages(): void {
        const current = root.wallpaperFolder
        root.wallpaperFolder = ""
        Qt.callLater(() => { root.wallpaperFolder = current })
    }

    // True when fileName is the current wallpaper (or an effect copy of it)
    function isCurrent(fileName): bool {
        if (root.currentWallpaper === "" || fileName === "")
            return false
        const current = root.currentWallpaper.substring(root.currentWallpaper.lastIndexOf("/") + 1)
        return current === fileName || current.endsWith("-" + fileName)
    }

    // Pass each value as its own argument. No shell reads the
    // file name, so quotes and spaces in it are safe.
    function apply(filePath, extraArgs): void {
        Quickshell.execDetached([root.wallpaperScript, filePath].concat(extraArgs || []))
    }
}
