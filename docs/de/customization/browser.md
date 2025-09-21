# Default Browser

<div align="center" class="tip custom-block" style="padding-top: 20px; padding-bottom: 20px;">

**Der Standardbrowser ist Firefox. Du kannst aber jeden beliebigen Browser als Standard setzen.**

</div>

As an example, let's install brave.

```sh
yay -S brave-bin
```

Öffne anschließend die ML4W Dotfiles Settings App mit `SUPER+CTRL+S`, wähle den Reiter Waybar, scrolle nach unten und ändere den Browser auf `brave`.

![image](/browser.png)

Führe dann folgenden Befehl in einem Terminal aus:

```sh
xdg-settings set default-web-browser brave.desktop
```

Um den Waybar-Quicklink für den Browser zu ändern, folge den Anweisungen im Abschnitt `Customize Waybar`.
