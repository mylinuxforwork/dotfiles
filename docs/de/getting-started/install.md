# Installation

## Installation mit dem Dotfiles Installer

::: warning VORAB
Bitte sichere deinen bestehenden `~/.config`-Ordner, bevor du die Skripte für die Erstinstallation ausführst.
:::

Du kannst die ML4W Dotfiles für Hyprland auf jeder Distribution mit dem Dotfiles Installer aus Flathub installieren. Klicke auf das Badge, um die App zu installieren:

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

::: warning VORAB
Der Dotfiles Installer erstellt ein Backup der Konfigurationen in deinem `.config`-Ordner, die durch die Installation überschrieben werden könnten.

Falls möglich, erstelle bitte zusätzlich einen System-Snapshot (z. B. mit snapper oder Timeshift).
:::

Kopiere die folgende URL in den Dotfiles Installer.

#### Stabile Version

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst
```
#### Rolling-Version

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```

Installationsskripte zur Einrichtung der benötigten Abhängigkeiten sind für Arch, Fedora und openSuse Tumbleweed enthalten.

Die Installation der Abhängigkeiten kann je nach Internetverbindung und Systemleistung zwischen 5 und 15 Minuten dauern.

::: info NICHT UNTERSTÜTZTE DISTRIBUTIONEN
Für andere Distros installiere zuerst die <a href="/dotfiles/getting-started/dependencies">Abhängigkeiten</a> und überspringe das Setup-Skript im Installer.
:::

Die Dotfiles werden in `~/.mydotfiles` installiert und per Symlink in `~/.config` eingebunden.

::: info EMPFEHLUNG
Ich empfehle, vorher ein Basis-Hyprland-System zu installieren. So hast du einen stabilen Ausgangspunkt, um Hyprland vorab zu testen. Hyprland ist komplex, in aktiver Entwicklung und benötigt zusätzliche Komponenten.

Unter Arch Linux kannst du zuerst das Hyprland Desktop Profile installieren.

Hyprland-Installationsanleitungen: https://wiki.hyprland.org/Getting-Started/Installation/
:::

### Für minimale Arch-Installationen

Installiere folgende Abhängigkeiten auf einem minimalen Arch-System:

```sh [<i class="devicon-archlinux-plain"></i> Arch]
sudo pacman -S hyprland vim kitty firefox flatpak

```
Starte danach das System neu und starte Hyprland mit:

```sh [<i class="devicon-archlinux-plain"></i> Arch]
Hyprland

```
Öffne Firefox, rufe die Dotfiles Installer-Seite auf und folge den Installationsanweisungen.

::: warning AUR nicht mehr unterstützt
Bitte beachte, dass AUR-Pakete für die ML4W Dotfiles nicht mehr unterstützt werden. Deinstalliere ggf. alte Pakete:

```sh
yay -R ml4w-dotfiles # Main Release
yay -R ml4w-dotfiles-git # Rolling Release
```
:::

## Installation mit GNU stow

Die manuelle Installation ohne Dotfiles Installer ist möglich, wird aber nicht empfohlen (insbesondere nicht für Einsteiger).

> [!NOTE]
> Erstelle vorher ein Backup deiner aktuellen Konfiguration. Diese Anleitung ist noch in Entwicklung.

Die manuelle Installation erfordert `stow`. Beispiel (Arch):

```sh
sudo pacman -S stow
```

Schritte:

```sh
mkdir -p ~/Projects # Erstelle ein Projects-Verzeichnis
git clone --depth 1 https://github.com/mylinuxforwork/dotfiles # Rolling Release
cd ~/Projects/dotfiles/setup # in das setup-Verzeichnis wechseln
./setup.sh # Setup-Skript ausführen, um Abhängigkeiten zu installieren
```
Erstelle Symlinks ins Home-Verzeichnis:

```sh
cd ~/Projects/dotfiles
stow dotfiles
```

Starte das System neu.

## Installation in einer virtuellen Maschine (KVM)

In virt-manager aktiviere 3D-Beschleunigung (Video Virtio) und setze "Listen type" auf "None" (Display Spice).

| Keybind | Aktion |
|--------|--------|
| <kbd>SUPER</kbd> + <kbd>CTRL</kbd> + <kbd>S</kbd> | Hyprland Settings öffnen |
| *(Inside Settings → Environments)* | Wähle `kvm.conf` für bessere VM-Unterstützung |

