Die Statusleiste der ML4W Dotfiles ist **Waybar**. Die Waybar-Konfiguration befindet sich in `~/dotfiles/waybar`.

### Waybar-Tastenkürzel

| Tastenkürzel | Aktion |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>B</kbd> | Waybar umschalten |
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>B</kbd> | Waybar-Theme neu laden |
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>T</kbd> | Waybar-Theme mit themeswitcher wechseln |
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>T</kbd> | Rofi-themeswitcher für Waybar öffnen |

## Waybar-Themes und themeswitcher

| Theme auswählen |
|-----------------|
| Verwende <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>T</kbd> (custom Hyprland key binding), um das Skript `themeswitcher.sh` auszuführen. Das Skript öffnet Rofi und zeigt Themes in `~/.config/waybar/themes/`. |

## Quicklinks definieren

Die Waybar enthält einen Bereich für Quicklinks.

![image](/bar.png)

Die Icons für ChatGPT und Settings sind fest. Alle anderen Icons kannst du in `~/.config/ml4w/settings/waybar-quicklinks.json` anpassen oder erweitern.

In der JSON-Datei kannst du bis zu 10 Quicklinks definieren und zur Quicklinks-Gruppe in Waybar hinzufügen:
https://github.com/mylinuxforwork/dotfiles/blob/main/share/dotfiles/.config/ml4w/settings/waybar-quicklinks.json

```sh
/*
Define your quick links for the statusbar here.
YOu can use icons from here https://fontawesome.com/search?ic=free
You can reload waybar with SUPER + SHIFT + B
*/
{
    "custom/quicklink_browser": {
        "format": "",
        "on-click": "~/.config/ml4w/settings/browser.sh",
        "tooltip-format": "Open Browser"
    },
    "custom/quicklink_filemanager": {
        "format": "",
        "on-click": "~/.config/ml4w/settings/filemanager.sh",
        "tooltip-format": "Open Filemanager"
    },
    "custom/quicklink_email": {
        "format": "",
        "on-click": "~/.config/ml4w/settings/filemanager.sh",
        "tooltip-format": "Open Email Client"
    },
    "custom/quicklink_chromium": {
        "format": "",
        "on-click": "chromium",
        "tooltip-format": "Open Chromium"
    },
    "custom/quicklink_edge": {
        "format": "",
        "on-click": "edge",
        "tooltip-format": "Open Edge"
    },
    "custom/quicklink_firefox": {
        "format": "",
        "on-click": "firefox",
        "tooltip-format": "Open Firefox"
    },
    "custom/quicklink_thunderbird": {
        "format": "",
        "on-click": "thunderbird",
        "tooltip-format": "Open Thunderbird"
    },
    "custom/quicklink_calculator": {
        "format": "",
        "on-click": "~/.config/ml4w/settings/calculator.sh",
        "tooltip-format": "Open calculator"
    },
/*
Don't remove the quicklinkempty
*/
    "custom/quicklinkempty": {
    },
/*
Add your quicklinks in your desired order to the status bar
*/
    "group/quicklinks": {
        "orientation": "horizontal",
        "modules": [

            "custom/quicklink_browser",
            "custom/quicklink_email",
            "custom/quicklink_filemanager",

/*
Don't remove the quicklinkempty
*/
            "custom/quicklinkempty"
        ]
    }
}
```
Diese Konfiguration enthält bereits einen vorbereiteten Quicklink für Firefox inkl. des passenden Symbols. Aktiviere ihn, indem du die Kommentar-Markierungen entfernst und Chromium entfernst.

| Nach Änderungen neu laden |
|--------------------------|
| Nach Änderungen an der Datei lade Waybar mit <kbd>`SUPER`</kbd> + <kbd>`SHIFT`</kbd> + <kbd>`B`</kbd> neu. |

Free Icons von Font Awesome findest du auf [fontawesome.com](https://fontawesome.com/search?o=r&m=free)

## Eigene `config` und `style.css` für ein ML4W-Theme

Wenn du Module aus den ML4W-Themes ausblenden oder das Styling anpassen möchtest, erstelle eine Kopie der Konfigurationsdatei mit dem Namen `config-custom` oder eine Kopie von `style.css` namens `style-custom.css`.

Der Waybar-Loader verwendet dann deine Kopien anstelle der Standarddateien.

Mit einer persönlichen `config-custom` kannst du auch eine eigene `modules.json` mit zusätzlichen Modulen laden.

## Eigenes Theme vom Starter-Theme ableiten

Prüfe die Konfigurationen in `~/dotfiles/waybar/themes/`.

Ein guter Startpunkt ist das Waybar Starter-Theme.

Kopiere den Ordner `~/.config/waybar/themes/starter` und benenne die Kopie z. B. in `mytheme` um.

Öffne die Datei `~/.config/waybar/themes/mytheme/config.sh` und gib deinem Theme einen Namen:

```sh
#!/bin/bash
theme_name="MyTheme"
```

| Theme auswählen |
|-----------------|
| Wähle dein Theme, indem du auf das "..."-Icon in Waybar klickst oder <kbd>`SUPER`</kbd> + <kbd>`CTRL`</kbd> + <kbd>`T`</kbd> verwendest. |

Um dein Theme anzupassen, kannst du `config`, `style.css` und `modules.json` bearbeiten.

| Theme neu laden |
|-----------------|
| Du kannst das Waybar-Theme mit <kbd>`SUPER`</kbd> + <kbd>`SHIFT`</kbd> + <kbd>`B`</kbd> neu laden. |

## Waybar Dokumentation

- Waybar configuration: https://github.com/Alexays/Waybar/wiki/Configuration
- Waybar Styling: https://github.com/Alexays/Waybar/wiki/Styling

