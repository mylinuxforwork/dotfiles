hl.on("hyprland.start", function ()
    local HOME = os.getenv("HOME")

    -- Read wallpaper app setting
    local wallpaper_app = "quickshell"
    local f = io.open(HOME .. "/.config/ml4w/settings/wallpaper-app", "r")
    if f then
        wallpaper_app = f:read("*l"):match("^%s*(.-)%s*$")
        f:close()
    end

    -- Export variables to systemd
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Restart portals so they catch the environment
    hl.exec_cmd("systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal")

    -- awww daemon
    hl.exec_cmd("awww-daemon")

    -- Load cursor
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

    -- Start listeners
    hl.exec_cmd("~/.config/ml4w/listeners.sh --startall")

    -- Start waybar
    hl.exec_cmd(HOME .. "/.config/waybar/launch.sh")

    -- Start polkit agent: prefer hyprpolkitagent.service (Ubuntu, via
    -- packages-ubuntu -- its unit is WantedBy=graphical-session.target,
    -- which Hyprland never activates, so start it explicitly), falling
    -- back to polkit-gnome-authentication-agent-1 where that unit
    -- doesn't exist. Only one should run -- starting both means
    -- duplicate polkit auth dialogs.
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service 2>/dev/null || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || true")

    -- Restore wallpaper (skip for quickshell — handled inside ml4w-autostart)
    if wallpaper_app ~= "quickshell" then
        hl.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app --restore")
    end

    -- Autostart scripts -- log to a dated file, keeping only the last 10
    -- logs (the 9 newest existing ones plus the one written now)
    hl.exec_cmd(
        "d=\"$HOME/.local/state/ml4w-os-hyprland\"; mkdir -p \"$d\"; " ..
        "ls -1r \"$d\"/ml4w-autostart-*.log 2>/dev/null | tail -n +10 | xargs -r rm -f; " ..
        "~/.config/ml4w/scripts/ml4w-autostart > \"$d/ml4w-autostart-$(date +%Y-%m-%d_%H-%M-%S).log\" 2>&1"
    )

    -- Load GTK settings
    hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")

    -- Start swaync -- skipped where D-Bus activation is already set up
    -- (marker written by post-ubuntu.sh), since an explicit exec-once
    -- there raced with it and lost with "already running!".
    hl.exec_cmd("[ -f ~/.config/ml4w/.swaync-dbus-activated ] || swaync")

    -- Start hypridle
    hl.exec_cmd("hypridle")

    -- Load cliphist history
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Start autostart cleanup
    hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")
end)
