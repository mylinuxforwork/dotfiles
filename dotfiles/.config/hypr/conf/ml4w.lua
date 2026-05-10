--    __  _____  _____      __  _____          ___
--   /  |/  / / / / / | /| / / / ___/__  ___  / _/
--  / /|_/ / /_/_  _/ |/ |/ / / /__/ _ \/ _ \/ _/
-- /_/  /_/____//_/ |__/|__/  \___/\___/_//_/_/
--

-- layerrule2 = blur, swaync-control-center
-- layerrule2 = blur, swaync-notification-window
-- layerrule2 = ignorezero, swaync-control-center
-- layerrule2 = ignorezero, swaync-notification-window
-- layerrule2 = ignorealpha 0.5, swaync-control-center
-- layerrule2 = ignorealpha 0.5, swaync-notification-window

-- Pavucontrol
hl.window_rule({
    name  = "pavucontrol",
    match = { class = ".*org.pulseaudio.pavucontrol.*" },
    float = true,
    center = true,
    size = "700 600"
})

-- ML4W Welcome App
hl.window_rule({
    name  = "ml4w-welcome-app",
    match = { title = "ML4W Welcome" },
    float = true,
    center = true,
    pin = true,
    size = "700 600"
})

-- PATHS
hl.env("PATH", "$PATH:$HOME/.cargo/bin")
hl.env("PATH", "$PATH:$HOME/.local/bin")

-- XDG Desktop Portal
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- QT
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- GDK
hl.env("GDK_SCALE", "1")

-- Toolkit Backend
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")

-- Mozilla
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Set the cursor size for xcursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Ozone
hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- SDL version
hl.env("SDL_VIDEODRIVER", "wayland")

-- Quickshell debug
hl.env("QS_NO_RELOAD_POPUP", "1")
