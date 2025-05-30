Some games are using old SDL version that is compiled without Wayland support. That means they will not likely want to run - crash on startup - if SDL_VIDEODRIVER is set to Wayland.

You can switch between wayland and x11 in the file ~/dotfiles/hypr/conf/custom.conf: 

```sh
# SDL version
env = SDL_VIDEODRIVER,wayland
# env = SDL_VIDEODRIVER,x11
```

Please note: In versions before 2.9.5RL you find the entry in ~/dotfiles/hypr/conf/ml4w.conf

# Toolkit Backend
env = GDK_BACKEND,wayland,x11,*
env = SDL_VIDEODRIVER,wayland
env = CLUTTER_BACKEND,wayland

Please move env = SDL_VIDEODRIVER,wayland to your custom.conf


