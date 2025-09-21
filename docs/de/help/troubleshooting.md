# Fehlerbehebung

## Probleme mit dem SDDM Sequoia Theme

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

Wenn du einen Fehler mit dem neuen Sequoia-Theme bemerkst, kannst du das Theme deinstallieren mit:

```sh
sudo rm -rf /usr/share/sddm/themes/sequoia
```

Öffne `/etc/sddm.conf.d/sddm.conf` und setze das Standardtheme zurück:

```ini
[Theme]
Current=elarum
```
</div>

## Waybar lädt nicht

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

Dass Waybar nicht lädt, tritt häufig nach einer frischen Installation der ML4W Dotfiles auf. Ursache kann der Startprozess von `xdg-desktop-portal-gtk` sein. Es kann auch passieren, wenn du Hyprland ein zweites Mal aus einer TTY heraus startest.

Wenn Waybar nicht lädt, starte zuerst das System neu und prüfe, ob das Problem weiterhin besteht.

Öffne ein Terminal mit `SUPER+Return` und gib `wlogout` ein.

Wenn es weiterhin nicht funktioniert, versuche `xdg-desktop-portal-gtk` zu entfernen:

```sh
sudo pacman -R xdg-desktop-portal-gtk
```

Starte das System erneut.

Waybar sollte nun funktionieren, allerdings verlierst du damit die Dunkelmodus-Unterstützung in Libadwaita-Apps (z. B. `nautilus`). Die ML4W Apps funktionieren weiterhin im Dunkelmodus.

Installiere es anschließend wieder mit:

```sh
sudo pacman -S xdg-desktop-portal-gtk
```

Bitte stelle außerdem sicher, dass `xdg-desktop-portal-gnome` nicht parallel zu `xdg-desktop-portal-gtk` installiert ist. Entferne gegebenenfalls das Paket.

Wenn das Problem weiterhin besteht, entferne `xdg-desktop-portal-gtk`. Falls du Dunkelmodus benötigst, installiere `dolphin`, `qt6ct` und aktiviere Breeze bzw. dunklere Farbschemata, um einen Dateimanager mit Dunkelmodus zu erhalten.

</div>

## Fehlende Icons in Waybar

<div class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

Bei fehlenden Icons in Waybar handelt es sich oft um einen Konflikt zwischen mehreren installierten Schriftarten (besonders auf **Arco Linux**). Stelle sicher, dass `ttf-ms-fonts` deinstalliert ist und `ttf-font-awesome` sowie `otf-font-awesome` installiert sind:

```sh
yay -R ttf-ms-fonts
yay -S ttf-font-awesome otf-font-awesome
```

</div>
