# Shell (Bash, ZSH, Fish)

Die ML4W-Dotfiles für Hyprland werden mit vorkonfigurierten Einstellungen für `bash`, `zsh` und `fish` ausgeliefert. Du kannst die Shell über die ML4W Welcome App ändern: Settings → System → Change Shell.

![image](/change-shell.jpg)

## `.zshrc` anpassen

Wenn du zusätzliche Einstellungen für `zsh` einbringen möchtest, erstelle eine Datei `.zshrc_custom` in deinem Home-Verzeichnis.

Für komplexere Anpassungen hast du folgende Möglichkeiten.

Die `.zshrc` lädt die Dateien aus dem Ordner `~/.config/zshrc` in dieser Reihenfolge:

* 00-init
* 10-aliases
* 20-customization
* 30-autostart

Du kannst eine eigene Datei in die Lade-Reihenfolge einfügen. Willst du z. B. nach `20-customization` eine Datei laden, erstelle `25-my-additions`.

Wenn du eine mitgelieferte Datei überschreiben möchtest, kopiere sie in den Unterordner `custom` mit demselben Dateinamen und nehme deine Anpassungen vor (z. B. um zusätzliche `oh-my-posh`-Plugins hinzuzufügen).

Deine Anpassungen sind gegen ML4W-Updates geschützt.

### oh-my-zsh

Die `zsh`-Konfiguration basiert auf `oh-my-zsh` zur Verwaltung von Plugins und `oh-my-posh` für das Prompt. Folgende Plugins sind installiert:

```sh
plugins=(
    git
    sudo
    web-search
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    copyfile
    copybuffer
    dirhistory
)
```
### FZF

Die Tastenkombination für FZF ist `CTRL + R` für die fuzzy History-Suche.

### oh-my-posh

Das Prompt basiert auf `oh-my-posh` und der großartigen, minimalen "zen"-Konfiguration von **Dreams of Autonomy**.

<iframe width="100%" height="400" src="https://www.youtube.com/embed/9U8LCjuQzdc" 
title="Dreams of Autonomy" frameborder="0" 
allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
allowfullscreen></iframe>

Wenn du ein eigenes Theme erstellen möchtest, speichere die Konfiguration in `~/.config/ohmyposh` und verlinke sie z. B. so:

```sh
# -----------------------------------------------------
# oh-my-posh prompt
# -----------------------------------------------------
# Custom Theme
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
```

Alternativ kannst du ein mitgeliefertes `oh-my-posh`-Theme aktivieren:

```sh
# Shipped Theme
eval "$(oh-my-posh init zsh --config /usr/share/oh-my-posh/themes/agnoster.omp.json)"
```

## `.bashrc` anpassen

Für `bash` gilt ein ähnliches Vorgehen: Erstelle `~/.bashrc_custom`, wenn du zusätzliche Einstellungen einbringen möchtest.

Die `.bashrc` lädt Dateien aus `~/.config/bashrc` in dieser Reihenfolge:

* 00-init
* 10-aliases
* 20-customization
* 30-autostart

Auch hier kannst du eigene Dateien in die Reihenfolge einfügen (z. B. `25-my-additions`) oder mitgelieferte Dateien im `custom`-Ordner überschreiben.

Deine Anpassungen sind gegen ML4W-Updates geschützt.

