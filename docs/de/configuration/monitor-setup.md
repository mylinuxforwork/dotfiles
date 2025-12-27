# Monitor-Einrichtung

Wenn du die Standard-Monitor-Konfiguration ändern möchtest, kannst du entweder eine persönliche Monitor-Variation anlegen oder `nwg-displays` verwenden.

## Persönliche Monitor-Variation

Öffne die ML4W Dotfiles Settings App und wähle den Reiter "System". Beim Herunterscrollen findest du die mitgelieferten Monitor-Variationen.

![image](/monitor.png)

Du kannst auch eine eigene Variation erstellen, wie in der Dokumentation beschrieben: [Configuration-Variations](https://github.com/mylinuxforwork/dotfiles/wiki/Configuration-Variations).

## Verwendung von nwg-displays

Die ML4W Dotfiles unterstützen die Anwendung [nwg-displays](https://github.com/nwg-piotr/nwg-displays) zur Konfiguration deiner Anzeigeeinstellungen.

Installiere `nwg-displays` für deine Distribution wie folgt:

::: code-group

```sh [<i class="devicon-archlinux-plain"></i> Arch]
sudo pacman -S nwg-displays
```

```sh [<i class="devicon-fedora-plain"></i> Fedora]
sudo dnf install python-build python-installer python-wheel python-setuptools
git clone https://github.com/nwg-piotr/nwg-displays ~/nwg-displays
cd ~/nwg-displays && chmod +x install.sh
sudo ./install.sh
```
```sh [<i class="devicon-opensuse-plain"></i> openSuse]
sudo zypper install nwg-displays
```

:::

Öffne die App und wende deine gewünschten Monitoreinstellungen an.

![image](/monitor1.png)

Anschließend öffne die ML4W Settings App und wähle die Monitor-Variation `nwg-displays`.

![image](/monitor2.png)

> Ab jetzt kannst du deine Monitoreinstellungen direkt in `nwg-displays` ändern.
