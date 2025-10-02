# Migration zum neuen Dotfiles Installer

Die ML4W Dotfiles für Hyprland werden mit dem Dotfiles Installer verwaltet. Du kannst deine bestehende (Legacy-)Installation auf das neue Dotfiles-Installer-Setup migrieren, indem du die folgenden Schritte ausführst.

::: info
Version 0.9.1 des Dotfiles Installer oder neuer wird benötigt
:::

### 1. Dotfiles Installer installieren

Klicke auf das Badge unten, um den Dotfiles Installer von Flathub zu installieren.

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

### 2. Dotfiles Installer starten

Öffne den App-Launcher oder starte die App über die Kommandozeile:

```sh
flatpak run com.ml4w.dotfilesinstaller
```
### 3. .dotinst-Datei laden und neueste Version herunterladen

Kopiere die folgende URL in den Dotfiles Installer und klicke auf "Load".

#### Stabile Version

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst
```
#### Rolling-Version

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```
Klicke anschließend auf "Download", um die neueste Version herunterzuladen.

Führe das Setup-Skript aus, um die aktuellen Abhängigkeiten zu installieren.

::: info
Du kannst den Setup-Schritt vermutlich überspringen, wenn du bereits die neueste Version installiert hast.
:::

### 4. Dotfiles migrieren

Nachdem du die Dotfiles heruntergeladen hast, öffne im Installer das Ordner-Menü und wähle "Open Prepared Folder". Ersetze alle Dateien im `prepared`-Ordner durch die Dateien und Ordner aus `~/dotfiles`.

![image](/migrate.jpg)

Anschließend klicke auf `Migrate from Prepared Folder`.

### 5. Konfiguration schützen

Wenn du eigene Anpassungen an den Dotfiles vorgenommen hast, wähle die Dateien und Ordner aus, die während Installation oder Update nicht überschrieben werden sollen. Deine Auswahl wird für zukünftige Updates gespeichert.

### 6. Dotfiles installieren

Du kannst die Dotfiles direkt installieren und aktivieren.

### 7. Dotfiles aktualisieren

Die Dotfiles können jederzeit über den Startbildschirm des Dotfiles Installer auf die neueste Version aktualisiert werden.
