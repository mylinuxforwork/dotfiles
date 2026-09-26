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

    -- Start polkit daemon
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- Ubuntu ships hyprpolkitagent instead (via packages-ubuntu), but its
    -- unit is WantedBy=graphical-session.target, which Hyprland never
    -- activates, so it has to be started explicitly. No-op on distros
    -- where the unit doesn't exist.
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service 2>/dev/null || true")

    -- Restore wallpaper (skip for quickshell — handled inside ml4w-autostart)
    if wallpaper_app ~= "quickshell" then
        hl.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app --restore")
    end

    -- Autostart scripts
    hl.exec_cmd("~/.config/ml4w/scripts/ml4w-autostart > ~/.mydotfiles/ml4w-autostart.log 2>&1")

    -- Load GTK settings
    hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")

    -- Start swaync -- except on Debian/Ubuntu, where it's deliberately
    -- left to D-Bus activation instead (org.erikreider.swaync.cc).
    -- Confirmed live there: an explicit exec-once here raced with D-Bus
    -- activation itself (e.g. from waybar's own swaync-client
    -- notification-count module firing around the same time) and lost
    -- with "An instance of SwayNotificationCenter is already running!".
    -- That's tied to Ubuntu's swaync.service packaging specifically
    -- (WantedBy=graphical-session.target, unmasked so D-Bus activation
    -- self-heals it) -- other distros' swaync packaging isn't known to
    -- have that same setup, so keep the direct launch there.
    hl.exec_cmd("[ -f /etc/debian_version ] || swaync")

    -- Start hypridle
    hl.exec_cmd("hypridle")

    -- Load cliphist history
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Start autostart cleanup
    hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")
end)
