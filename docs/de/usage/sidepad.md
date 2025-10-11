# Sidepad

Der Sidepad ist ein praktisches Feature, um dauerhaft ein Fenster auf allen Arbeitsflächen verfügbar zu haben.

![image](/sidepad-open.jpg)

Beim Aufrufen des Sidepad erscheint der rechte Fensterrahmen am linken Bildschirmrand. Mit Tastenkürzeln kannst du das Fenster ein- oder vollständig vergrößern.

![image](/sidepad-closed.jpg)

Der Sidepad eignet sich als Ersatz für ein Scratchpad, für Terminals oder KI-Hilfen, die dauerhaft erreichbar sein müssen.

## Tastenkürzel

Die ML4W Dotfiles enthalten folgende Sidepad-Tastenkürzel:

- SUPER + S: Sidepad initialisieren
- SUPER + Shift + S: Öffnet den Sidepad-Selector
- SUPER + CTRL + rechts: Öffnet den Sidepad in kompakter Breite
- SUPER + CTRL + rechts: Öffnet den Sidepad in voller Breite
- SUPER + CTRL + links: Schließt den Sidepad

Du findest zusätzlich eine spezielle Sektion in der ML4W Sidebar.

## Konfiguration

Der Sidepad in den ML4W Dotfiles wird mit folgenden Konfigurationen ausgeliefert:

### Terminal

```sh
# Sidepad-Konfiguration für Kitty
SIDEPAD_APP="kitty"
SIDEPAD_CLASS="dotfiles-sidepad"
```

### KI-Unterstützung

```sh
# Sidepad-Konfiguration für Newelle
# Installation: flatpak install io.github.qwersyk.Newelle
SIDEPAD_APP="flatpak run io.github.qwersyk.Newelle"
SIDEPAD_CLASS="io.github.qwersyk.Newelle"
SIDEPAD_OPTIONS="--width 700"
```
### Browser

```sh
# Sidepad-Konfiguration für Firefox
SIDEPAD_APP="firefox --no-remote -P default --name dotfiles-sidepad"
SIDEPAD_CLASS="dotfiles-sidepad"
```

Du kannst eigene Sidepad-Konfigurationen in `~/.config/sidepad/pads` ablegen. Die Konfiguration erscheint automatisch im Sidepad-Selector.

## Scripting

Das Sidepad-Skript funktioniert auch eigenständig ohne die ML4W Dotfiles.

Das Skript findest du hier: https://github.com/mylinuxforwork/dotfiles/tree/main/dotfiles/.config/sidepad

```sh
Options:
  --class <name>         Override the window class (Default: dotfiles-sidepad)
  --hidden-gap <px>      Override the hidden left gap (Default: 10)
  --visible-gap <px>     Override the visible left gap (Default: 20)
  --width <px>           Override the target width (Default: 500)
  --width-max <px>       Override the maximum target width (Default: 1000)
  --top-gap <px>         Override the top gap (Default: 76)
  --bottom-gap <px>      Override the bottom gap (Default: 91)
  --hide                 Force the window to the hidden state.
  --kill                 Kills the running app with WINDOW_CLASS.
  -h, --help             Display this help and exit
```

Du kannst die Sidepad-Funktionen skripten, indem du ein eigenes Dispatcher-Skript erstellst und es mit deinen Tastenkürzeln verbindest.

Der Sidepad-Dispatcher für die ML4W Dotfiles ist hier verfügbar: https://github.com/mylinuxforwork/dotfiles/blob/main/dotfiles/.config/ml4w/scripts/sidepad.sh


