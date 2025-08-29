# Switch SDL

Some games are using old SDL version that is compiled without Wayland support. That means they will not likely want to run - crash on startup - if `SDL_VIDEODRIVER` is set to Wayland.**

You can switch between wayland and x11 in the file `~/dotfiles/hypr/conf/custom.conf`: 

```sh
# SDL version
env = SDL_VIDEODRIVER,wayland
# env = SDL_VIDEODRIVER,x11
```

> [!NOTE]
> In versions before 2.9.5RL you find the entry in `~/dotfiles/hypr/conf/ml4w.conf`

## Toolkit Backend Environment Variables

These environment variables help ensure proper backend support in Hyprland:

| Variable | Value |
|----------|-------|
| `GDK_BACKEND` | `wayland,x11,*` |
| `SDL_VIDEODRIVER` | `wayland` |
| `CLUTTER_BACKEND` | `wayland` |

> [!TIP]  
> Move the following line to your `custom.conf` file for better control:
>
> ```ini
> env = SDL_VIDEODRIVER,wayland
> ```



