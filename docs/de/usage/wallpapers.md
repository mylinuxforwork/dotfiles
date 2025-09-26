# Wallpaper mit Waypaper (hyprpaper; swww optional)

Du kannst ein Wallpaper mit Waypaper auswählen. Waypaper lässt sich über den App-Launcher oder die Sidebar starten.

> [!NOTE]
> Zusätzliche Wallpaper findest du im ML4W Wallpaper Repository: https://github.com/mylinuxforwork/wallpaper

### 🎨 Wallpaper-Tastenkürzel

| Tastenkürzel | Aktion |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>W</kbd> | Wallpaper ändern (zufällig aus `~/wallpaper/`) |
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>W</kbd> | Waypaper öffnen |
| <kbd>SUPER</kbd> + <kbd>ALT</kbd> + <kbd>W</kbd> | Wallpaper-Automatik starten/stoppen |

![image](/wallpapers.png)

> In Waypaper kannst du ein Wallpaper aus jedem Ordner deines Systems auswählen.

> Die Standard-Wallpaper-Engine ist **`hyprpaper`**. Optional kannst du **swww** installieren und in der ML4W Settings App von `hyprpaper` auf `swww` wechseln.

> Öffne die ML4W Settings App und wähle den Tab „System“. Oben findest du den Wallpaper-Engine-Selector.

> [!NOTE]
> Ein Logout und Login ist erforderlich, um die neue Wallpaper-Anwendung zu aktivieren.

Die `hyprpaper`-Engine verwendet eine Template-Datei unter `dotfiles/.settings/hyprpaper.tpl`. Dort kannst du zusätzliche Konfigurationen ergänzen. Platzhalter wie `WALLPAPER` werden mit dem ausgewählten Wallpaper ersetzt.

## Wallpaper-Automatik

Du kannst die automatische Wallpaper-Änderung mit dem oben genannten Tastenkürzel aktivieren. Der Prozess lässt sich mit demselben Tastenkürzel stoppen.

Die Wartezeit (in Sekunden) zwischen den Wechseln (Standard: 60 Sekunden) kannst du in `~/.config/ml4w/settings/wallpaper-automation.sh` einstellen.

## Wallpaper-Effekte

Du kannst Wallpaper-Effekte aktivieren, um die Darstellung des ausgewählten Hintergrundbilds zu verändern. Ein Rechtsklick auf das Wallpaper-Symbol in Waybar öffnet ein Menü zur Auswahl des Effekts.

![Screenshot](/wall-effect.png)

Eigene Effekte legst du in `/dotfiles/hypr/effects/wallpaper` ab.

Du kannst mehrere `magick`-Befehle ausführen. `$wallpaper` ist das ausgewählte Wallpaper, `$used_wallpaper` die erzeugte Version.

```sh
magick $wallpaper -negate $used_wallpaper
magick $used_wallpaper -brightness-contrast -20% $used_wallpaper
```

## Wallpaper-Cache

Generierte Versionen eines Wallpapers werden im Ordner `~/.config/ml4w/cache/wallpaper-generated` zwischengespeichert. Dadurch beschleunigt sich der Wechsel zwischen Wallpapers, falls gecachte Dateien vorhanden sind.

Du kannst den Cache in der ML4W Settings App deaktivieren.

Den Cache kannst du in der ML4W Settings App leeren oder mit:

```sh
~/.config/hypr/scripts/wallpaper-cache.sh
```

Du kannst die Version des aktuellen Wallpapers neu erzeugen, indem du den Cache in den Einstellungen ausschaltest und dasselbe Wallpaper erneut auswählst.

## ML4W Wallpaper Repository

Weitere Wallpaper findest du im [ML4W Wallpaper repository](https://github.com/mylinuxforwork/wallpaper/blob/main/README.md)

