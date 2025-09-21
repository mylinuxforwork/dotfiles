# Deinstallation der ML4W Dotfiles

Die Deinstallation erfordert einige manuelle Schritte. Dazu gehören das Entfernen der Dotfiles, das Wiederherstellen von Konfigurationsdateien aus dem Backup und das Deinstallieren nicht mehr benötigter Abhängigkeiten.

> [!WARNING]
> Die Deinstallation ist ein sehr individueller Prozess. Es gibt keine Garantie, dass die folgenden Schritte auf allen Systemen funktionieren.

> [!NOTE]
> Die folgenden Anweisungen sind noch in Arbeit. Der Dotfiles Installer wird in einem der kommenden Updates eine Deinstallationsfunktion enthalten. Teile bitte deine Erfahrungen auf GitHub.

## Entferne die Hyprland-Konfiguration

Melde dich von den ML4W Dotfiles ab und wechsle zu einer anderen Desktop-Umgebung (falls vorhanden) oder auf eine TTY.

```sh
cd ~/.config # ins Config-Verzeichnis wechseln
rm -rf hypr # Entfernt den aktuellen Symlink zur ML4W hypr-Konfiguration
```
Wenn du auf einer TTY arbeitest, kannst du dich danach wieder bei Hyprland anmelden und solltest die Standardkonfiguration sehen. Bitte beachte, dass du jetzt kitty mit SUPER+Q öffnen musst.

## Stelle dein erstes Backup wieder her

Kopiere die Dateien aus deinem ersten Backup, das du mit dem Dotfiles Installer erstellt hast, zurück in dein Home- und `.config`-Verzeichnis. Halte die Ordnerstruktur deines Backups bei.

Das Backup-Verzeichnis findest du hier:

```sh
cd ~/.var/app/com.ml4w.dotfilesinstaller/data/backup
cd com.ml4w.dotfiles # für Rolling Release
cd com.ml4w.dotfiles.stable # für Stable Release
```
## Symlinks löschen (optional)

Entferne alle Symlinks in deinem Home- und `.config`-Verzeichnis, die auf den `.mydotfiles`-Ordner zeigen.

```sh
cd ~/.config
rm -rf waybar # Beispiel
```

## Dotfiles-Ordner entfernen (optional)

Öffne den folgenden Ordner und entferne die Dotfiles:

```sh
cd ~/.mydotfiles
rm -rf com.ml4w.dotfiles # für Rolling Release
rm -rf com.ml4w.dotfiles.stable # für Stable Release
```
## Abhängigkeiten deinstallieren (optional)

Du kannst <a href="/dotfiles/getting-started/dependencies">Abhängigkeiten</a> entfernen, die du nicht mehr benötigst.

> [!WARNING]
> Bitte stelle sicher, dass du keine Pakete entfernst, die für dein System erforderlich sind.

## ML4W Apps deinstallieren

Führe die folgenden Befehle aus, um die ML4W Flatpak-Apps von deinem System zu entfernen:

```sh
flatpak uninstall com.ml4w.welcome
flatpak uninstall com.ml4w.settings
flatpak uninstall com.ml4w.calendar
flatpak uninstall com.ml4w.sidebar
flatpak uninstall com.ml4w.hyprlandsettings

```
