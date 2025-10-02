
# Display Manager

Dieses Tutorial führt dich durch die Installation eines Display Managers wie SDDM und das Wechseln zwischen verschiedenen Display Managern (z. B. SDDM und GDM) auf einem Linux-System. Display Manager bieten eine grafische Anmeldemaske und verwalten Benutzersitzungen.

> [!NOTE]
> Die ML4W Dotfiles enthalten keine Display-Manager-Konfiguration, um nicht direkt sensible Systemkomponenten wie Display Manager zu manipulieren.

Aktualisiere zuerst deine Paketliste, bevor du einen Display Manager installierst.

::: code-group

```sh [Arch]
sudo pacman -Syu
```

```sh [Fedora]
sudo dnf update
```

```sh [openSuze]
sudo zypper update
```
:::

## SDDM

### SDDM für deine Distribution installieren:

::: code-group

```sh [Arch]
sudo pacman -S sddm
```

```sh [Fedora]
sudo dnf install sddm
```

```sh [openSuze]
sudo zypper install sddm
```
:::


### SDDM aktivieren (falls nicht automatisch aktiviert)

Während der Installation kann es sein, dass einige Distributionen dich auffordern, den Standard-Display-Manager auszuwählen. Falls nicht, oder wenn du ihn explizit aktivieren möchtest, kannst du dies tun.

Für Systeme mit systemd (die meisten modernen Distributionen):

```sh
sudo systemctl enable sddm
```

Wenn zuvor ein anderer Display Manager (z. B. GDM) aktiviert war, deaktiviert das Aktivieren von SDDM diesen in der Regel automatisch. Wenn du sicher gehen möchtest, kannst du den alten explizit deaktivieren (z. B. GDM):

```sh
sudo systemctl disable gdm # Nur falls GDM zuvor aktiviert war
```
### SDDM-Themes installieren

Die Installation eines SDDM-Themes hängt vom jeweiligen Theme-Entwickler ab. Viele großartige SDDM-Themes findest du auf Gnome Look: https://www.gnome-look.org/browse?cat=101&ord=top

Die Installation eines benutzerdefinierten SDDM-Themes umfasst in der Regel das Herunterladen des Themes, Entpacken, Verschieben in das richtige Verzeichnis und das Konfigurieren von SDDM.


#### Schritt 1: Theme herunterladen

1. Öffne deinen Webbrowser und gehe zur Theme-Seite: https://www.gnome-look.org/p/1312658
2. Navigiere zum Reiter "Files" auf der Theme-Seite.
3. Lade die neueste Version des Themes herunter (meist ein .tar.gz oder .zip). Für das "Nordic"-Theme suche nach einer Datei wie Nordic-SDDM.tar.gz.

> [!TIP]
> Merke dir, wo die Datei gespeichert wird (z. B. dein Downloads-Ordner).

#### Schritt 2: Theme entpacken

1. Öffne ein Terminal.
2. Wechsle in das Verzeichnis, in das du das Theme heruntergeladen hast. Beispiel:

```sh
cd ~/Downloads
```
3. Entpacke das heruntergeladene Archiv.

Wenn es eine .tar.gz-Datei ist:

```sh
tar -xvf Nordic-SDDM.tar.gz
```

Wenn es eine .zip-Datei ist:

```sh
unzip Nordic-SDDM.zip
```
Dies erstellt ein neues Verzeichnis (z. B. Nordic-SDDM oder Nordic) mit den Theme-Dateien.

#### Schritt 3: Theme in das SDDM-Themes-Verzeichnis verschieben

SDDM-Themes liegen typischerweise in `/usr/share/sddm/themes/`. Du benötigst `sudo`, um Dateien in dieses Verzeichnis zu verschieben.

Verschiebe das entpackte Theme-Verzeichnis in das SDDM-Themes-Verzeichnis. Ersetze `Nordic-SDDM` durch den tatsächlichen Verzeichnisnamen.

```sh
sudo mv Nordic-SDDM /usr/share/sddm/themes/
```
> [!NOTE]
> Achte darauf, das gesamte Theme-Verzeichnis (nicht nur dessen Inhalt) nach `/usr/share/sddm/themes/` zu verschieben.

#### Schritt 4: SDDM konfigurieren, damit es das neue Theme verwendet

Bearbeite die SDDM-Konfigurationsdatei und setze das Theme (z. B. `/etc/sddm.conf` oder eine Datei unter `/etc/sddm.conf.d/`).

```sh
sudo vim /etc/sddm.conf
```

1. Finde den Abschnitt `[Theme]` oder füge ihn hinzu.
2. Setze `Current=` auf den Namen des Theme-Ordners, z. B.:

```ini
[Theme]
Current=Nordic-SDDM
```

3. Speichere und beende den Editor.

Alternative: Lege eine Datei unter `/etc/sddm.conf.d/` an, falls `/etc/sddm.conf` nicht vorhanden ist.

```sh
sudo vim /etc/sddm.conf.d/custom-theme.conf
```

Füge dann den Abschnitt hinzu:

```ini
[Theme]
Current=Nordic-SDDM
```

#### Schritt 5: Änderungen anwenden

Starte den SDDM-Dienst neu:

```sh
sudo systemctl restart sddm
```
> [!WARNING]
> Dieser Befehl bringt dich sofort zurück zum Login-Bildschirm. Speichere vorher alle offenen Arbeiten.

Nach dem Neustart solltest du das neue SDDM-Theme sehen. Bei Problemen überprüfe Verzeichnisnamen und die `Current=`-Einstellung auf Tippfehler.

## Zwischen Display Managern wechseln

Die meisten Distributionen bieten einfache Möglichkeiten, zwischen installierten Display Managern zu wechseln. Beispiel:

SDDM deaktivieren:

```sh
sudo systemctl disable sddm
```

GDM aktivieren:

```sh
sudo systemctl enable gdm # oder gdm3
```

SDDM stoppen und GDM starten (optional):

```sh
sudo systemctl stop sddm
sudo systemctl start gdm # oder gdm3
```

System neu starten:

```sh
sudo reboot
```
