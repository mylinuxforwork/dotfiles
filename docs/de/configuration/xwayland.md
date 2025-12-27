# SDL umschalten

Einige Spiele verwenden veraltete SDL-Versionen, die ohne Wayland-Unterstützung kompiliert wurden. Das bedeutet, dass sie wahrscheinlich nicht starten (oder beim Start abstürzen), wenn `SDL_VIDEODRIVER` auf `wayland` gesetzt ist.**

Du kannst zwischen Wayland und X11 in der Datei `~/dotfiles/hypr/conf/custom.conf` wechseln:

```sh
# SDL-Version
env = SDL_VIDEODRIVER,wayland
# env = SDL_VIDEODRIVER,x11
```

> [!NOTE]
> In Versionen vor 2.9.5RL findest du den Eintrag in `~/dotfiles/hypr/conf/ml4w.conf`

## Toolkit-Backend Umgebungsvariablen

Diese Umgebungsvariablen stellen sicher, dass die richtigen Backends in Hyprland verwendet werden:

| Variable | Wert |
|----------|------|
| `GDK_BACKEND` | `wayland,x11,*` |
| `SDL_VIDEODRIVER` | `wayland` |
| `CLUTTER_BACKEND` | `wayland` |

> [!TIP]
> Verschiebe die folgende Zeile in deine `custom.conf`, um mehr Kontrolle zu haben:
>
> ```ini
> env = SDL_VIDEODRIVER,wayland
> ```



