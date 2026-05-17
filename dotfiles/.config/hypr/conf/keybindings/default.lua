-- Configuration
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("~/.config/ml4w/settings/terminal.sh"),      { description = "Open the terminal" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.config/ml4w/settings/browser.sh"),            { description = "Open the browser" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("~/.config/ml4w/settings/filemanager"),           { description = "Open the filemanager" })
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd("~/.config/ml4w/settings/emojipicker.sh"), { description = "Open the emoji picker" })
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("~/.config/ml4w/settings/calculator.sh"),  { description = "Open the calculator" })

-- Display
-- bind = $mainMod SHIFT, mouse_down, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}") # Increase display zoom
-- bind = $mainMod SHIFT, mouse_up, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}") # Decrease display zoom
-- bind = $mainMod SHIFT, Z, exec, hyprctl keyword cursor:zoom_factor 1 # Reset display zoom

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}),        { description = "Move to workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }), { description = "Move active window to workspace " .. i })
end

-- Windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close active window" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill(), { description = "Kill all active instances of application" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle", description = "Toggle Fullscreen" }))
-- bind = $mainMod, M, fullscreen, 1                                                           # Maximize Window
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
-- bindd = $mainMod SHIFT, T, Float all windows, exec, ~/.config/ml4w/scripts/ml4w-toggle-allfloat # Toggle floating for all windows of workspace
-- bind = $mainMod ALT, T, exec, ~/.config/ml4w/scripts/ml4w-toggle-float-pin                  # Toggle active window into floating + pinned mode
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }), { description = "Move focus up" })
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }), { description = "Move focus down" })

-- Actions
hl.bind(mainMod .. " + CTRL + R",      hl.dsp.exec_cmd("hyprctl reload"),                                               { description = "Reload Hyprland configuration" })
hl.bind(mainMod .. " + SHIFT + A",     hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-animations.sh"),                  { description = "Toggle animations" })
hl.bind(mainMod .. " + PRINT",         hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"),                         { description = "Take a screenshot" })
hl.bind(mainMod .. " + ALT + F",       hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"),                         { description = "Take an instant full-screen screenshot" })
hl.bind(mainMod .. " + ALT + S",       hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"),                         { description = "Take an instant area screenshot" })
hl.bind(mainMod .. " + ALT + A",       hl.dsp.exec_cmd("~/.config/hypr/scripts/text-extractor.sh"),                     { description = "Extract text from an area" })
hl.bind(mainMod .. " + CTRL + P",      hl.dsp.exec_cmd("qs ipc call power toggle"),                                     { description = "Start Power Menu" })
hl.bind(mainMod .. " + SHIFT + W",     hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app --random"),           { description = "Change the wallpaper" })
hl.bind(mainMod .. " + CTRL + W",      hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app"),                    { description = "Open wallpaper selector" })
hl.bind(mainMod .. " + ALT + W",       hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-automation"),             { description = "Start random wallpaper script" })
hl.bind(mainMod .. " + CTRL + RETURN", hl.dsp.exec_cmd("~/.config/hypr/scripts/launcher.sh"),                           { description = "Open application launcher" })
hl.bind(mainMod .. " + CTRL + K",      hl.dsp.exec_cmd("~/.config/hypr/scripts/keybindings.sh"),                    { description = "Show keybindings" })
hl.bind(mainMod .. " + SHIFT + B",     hl.dsp.exec_cmd("~/.config/waybar/launch.sh"),                                   { description = "Reload waybar" })
hl.bind(mainMod .. " + CTRL + B",      hl.dsp.exec_cmd("~/.config/waybar/toggle.sh"),                                   { description = "Toggle waybar" })
hl.bind(mainMod .. " + SHIFT + R",     hl.dsp.exec_cmd("~/.config/hypr/scripts/loadconfig.sh"),                         { description = "Reload hyprland config" })
hl.bind(mainMod .. " + V",             hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-cliphist"),                         { description = "Open clipboard manager" })
hl.bind(mainMod .. " + CTRL + T",      hl.dsp.exec_cmd("~/.config/waybar/themeswitcher.sh"),                            { description = "Open waybar theme switcher" })
hl.bind(mainMod .. " + SHIFT + M",     hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-theme"),                     { description = "Toggle between light and dark mode" })
hl.bind(mainMod .. " + CTRL + S",      hl.dsp.exec_cmd("qs ipc call sidebar toggle"),                                   { description = "Open ML4W Sidebar widget" })
hl.bind(mainMod .. " + CTRL + C",      hl.dsp.exec_cmd("qs ipc call calendar toggle"),                                  { description = "Open ML4W Calendar widget" })
hl.bind(mainMod .. " + ALT + G",       hl.dsp.exec_cmd("~/.config/hypr/scripts/gamemode.sh"),                           { description = "Toggle game mode" })
hl.bind(mainMod .. " + CTRL + L",      hl.dsp.exec_cmd("pidof hyprlock || hyprlock"),                                   { description = "Lock Screen" })
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-hyprsunset"),                { description = "Toggle Hyprsunset" })
hl.bind(mainMod .. " + Tab",           hl.dsp.exec_cmd("qs -p ~/.config/quickshell/overview ipc call overview toggle"), { description = "Open Select Window Menu" })
hl.bind(             "CTRL + ALT + T", hl.dsp.exec_cmd("~/.config/ml4w/themes/themes.sh"),                              { description = "Open Select Window Menu" })

--[[
bindm = $mainMod, mouse:272, movewindow                                                     # Move window with the mouse
bindm = $mainMod, mouse:273, resizewindow                                                   # Resize window with the mouse
bind = $mainMod SHIFT, right, resizeactive, 100 0                                           # Increase window width with keyboard
bind = $mainMod SHIFT, left, resizeactive, -100 0                                           # Reduce window width with keyboard
bind = $mainMod SHIFT, down, resizeactive, 0 100                                            # Increase window height with keyboard
bind = $mainMod SHIFT, up, resizeactive, 0 -100                                             # Reduce window height with keyboard
bind = $mainMod, G, togglegroup                                                             # Toggle window group
bind = $mainMod, K, layoutmsg, swapsplit                                                    # Swapsplit
bind = $mainMod ALT, left, swapwindow, l                                                    # Swap tiled window left
bind = $mainMod ALT, right, swapwindow, r                                                   # Swap tiled window right
bind = $mainMod ALT, up, swapwindow, u                                                      # Swap tiled window up
bind = $mainMod ALT, down, swapwindow, d                                                    # Swap tiled window down
binde = ALT,Tab,cyclenext                                                                   # Cycle between windows
binde = ALT,Tab,bringactivetotop                                                            # Bring active window to the top
]]--

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"), { description = "Exit Hyprland" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Toggle psuedotiling current window" })

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"),            { description = "Toggle special workspace" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), { description = "Move window to special workspace" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Move to next workspace" })
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { description = "Move to previous workspace" })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Drag window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Move window" })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true, description = "Increase volume" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true, description = "Decrease volume" })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true, description = "Mute/Unmute audio output" })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true, description = "Mute/Unmute microphone" })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true, description = "Increase monitor brightness" })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true, description = "Decrease monitor brightness" })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true, description = "Audio/Video play next" })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true, description = "Audio/Video play previous" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Audio/Video pause" })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Audio/Video play" })
