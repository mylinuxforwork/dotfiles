# Dotfiles Einstellungen

Du kannst die ML4W Dotfiles Einstellungen mit `SUPER + CTRL + S` öffnen, um ausgewählte Dotfiles-Konfigurationen zu ändern und Variationen für deine `hyprland.conf` zu wählen, damit du dein Desktop-Setup weiter anpassen kannst.

![Screenshot](/settings.jpg)

Du kannst eigene Variationen erstellen, indem du eine Datei aus den Unterordnern `~/dotfiles/hypr/conf` (z. B. `monitor/default.conf`) kopierst, der Datei einen eigenen Namen gibst (z. B. `mymonitor.conf`) und die Variation in der Dotfiles-Einstellungs-App im entsprechenden Bereich auswählst.

> [!IMPORTANT]
> Die ML4W Dotfiles Settings App ersetzt Strings in mehreren Konfigurationsdateien direkt oder anhand von Ersetzungs-Kommentaren (z. B. // START WORKSPACES). Entferne diese Kommentare oder Marker nicht, damit die App vollständig funktioniert.

Du kannst auch die Datei `custom.conf` bearbeiten, welche am Ende der `hyprland.conf` eingebunden wird und deine persönlichen Einstellungen aufnehmen kann.

Den Quellcode findest du im Repository der ML4W Dotfiles Settings App: https://github.com/mylinuxforwork/dotfiles-settings

Du kannst die Dotfiles App auch aus dem Terminal starten mit:

```sh
ml4w-settings
```
