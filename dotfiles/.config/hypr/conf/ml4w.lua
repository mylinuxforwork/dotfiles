--    __  _____  _____      __  _____          ___
--   /  |/  / / / / / | /| / / / ___/__  ___  / _/
--  / /|_/ / /_/_  _/ |/ |/ / / /__/ _ \/ _ \/ _/
-- /_/  /_/____//_/ |__/|__/  \___/\___/_//_/_/
--

-- HOME directory
local HOME = os.getenv("HOME")

-- Add .local/bin to PATH
local current_path = os.getenv("PATH")
hl.env("PATH", HOME .. "/.local/bin:" .. current_path)

-- Add .cargo/bin to PATH
local current_path = os.getenv("PATH")
hl.env("PATH", HOME .. "/.cargo/bin:" .. current_path)

-- Pavucontrol
hl.window_rule({
    name = "pavucontrol",
    match = {class = "*org.pulseaudio.pavucontrol*"},
    float = true,
    center = true,
    size = "700 600"
})

-- ML4W Welcome App
hl.window_rule({
    name = "ml4w-welcome-app",
    match = {title = "ML4W Welcome"},
    float = true,
    center = true,
    pin = true,
    size = "700 600"
})

-- ML4W Settings App
hl.window_rule({
    name = "ml4w-settings-app",
    match = {title = "ML4W Dotfiles Settings"},
    float = true,
    center = true,
    pin = true,
    size = "900 600"
})

-- Waypaper
hl.window_rule({
    name = "waypaper",
    match = {class = "*waypaper*"},
    float = true,
    center = true,
    pin = true,
    size = "900 700"
})

-- Newelle
hl.window_rule({
    name = "newelle",
    match = {class = "io.github.qwersyk.Newelle"},
    float = true,
    center = true,
    pin = true,
    size = "1000 700"
})

-- Blueman Manager
hl.window_rule({
    name = "blueman-manager",
    match = {class = "blueman-manager"},
    float = true,
    center = true,
    size = "800 600"
})

-- nwg-look
hl.window_rule({
    name = "nwg-look",
    match = {class = "nwg-look"},
    float = true,
    center = true,
    size = "700 600"
})

-- nwg-displays
hl.window_rule({
    name = "nwg-displays",
    match = {class = "nwg-displays"},
    float = true,
    center = true,
    size = "900 600"
})

-- System Mission Center
hl.window_rule({
    name = "missioncenter",
    match = {class = "io.missioncenter.MissionCenter"},
    float = true,
    center = true,
    pin = true,
    size = "900 600"
})

-- Gnome Calculator
hl.window_rule({
    name = "gnome-calculator",
    match = {class = "org.gnome.Calculator"},
    float = true,
    center = true,
    size = "700 600"
})

-- Hyprland Share Picker
hl.window_rule({
    name = "hyprland-share-picker",
    match = {class = "hyprland-share-picker"},
    float = true,
    pin = true,
    center = true,
    size = "600 400"
})

-- GTK File and Folder Picker
hl.window_rule({
    name = "xdg-desktop-portal-gtk",
    match = {class = "xdg-desktop-portal-gtk"},
    float = true,
    center = false,
    size = "800 600"
})

-- nm-connection-editor
hl.window_rule({
    name = "nm-connection-editor",
    match = {class = "nm-connection-editor"},
    float = true,
    center = true,
    size = "800 700"
})

-- Hyprmod
hl.window_rule({
    name = "io.github.bluemancz.hyprmod",
    match = {class = "io.github.bluemancz.hyprmod"},
    float = true,
    center = true,
    size = "1000 700"
})

-- ML4W Floating
hl.window_rule({
    name = "dotfiles-floating",
    match = {class = "dotfiles-floating"},
    float = true,
    center = true,
    size = "1000 700"
})

-- ML4W Sidepad
hl.window_rule({
    name = "dotfiles-sidepad",
    match = {class = "dotfiles-sidepad"},
    float = true,
    pin = true,
    center = true,
    size = "1000 700"
})

-- Picture-in-Picture
hl.window_rule({
    name = "Picture-in-Picture",
    match = {
        title = [[^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$]]
    },
    float = true,
    pin = true,
    focus_on_activate = false,
    no_initial_focus = true,
    suppress_event = "activate"
})

-- Wayland variables
hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("DESKTOP_SESSION", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- Qt related environment variables
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- XDG Desktop Portal
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- GDK
hl.env("GDK_SCALE", "1")

-- Toolkit Backend
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")

-- Mozilla
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Set the cursor size for xcursor
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- SDL version
hl.env("SDL_VIDEODRIVER", "wayland")

-- Quickshell debug
hl.env("QS_NO_RELOAD_POPUP", "1")

-- Force zero scaling for XWayland
hl.config({
  xwayland = {
    force_zero_scaling = true
  }
})