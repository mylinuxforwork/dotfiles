-- Configuration
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local HYPRSCRIPTS = "~/.config/hypr/scripts"
local SCRIPTS = "~/.config/ml4w/scripts"

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("~/.config/ml4w/settings/terminal.sh")) -- Open the terminal
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.config/ml4w/settings/browser.sh")) -- Open the browser
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("~/.config/ml4w/settings/filemanager")) -- Open the filemanager
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd("~/.config/ml4w/settings/emojipicker.sh")) -- Open the emoji picker
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("~/.config/ml4w/settings/calculator.sh")) -- Open the calculator

-- Display
-- bind = $mainMod SHIFT, mouse_down, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}") # Increase display zoom
-- bind = $mainMod SHIFT, mouse_up, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}") # Decrease display zoom
-- bind = $mainMod SHIFT, Z, exec, hyprctl keyword cursor:zoom_factor 1 # Reset display zoom

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close()) -- Kill active window
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill")) -- Quit active window and all open instances
-- bind = $mainMod, F, fullscreen, 0                                                           # Set active window to fullscreen
-- bind = $mainMod, M, fullscreen, 1                                                           # Maximize Window
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" })) -- Toggle Floating
-- bindd = $mainMod SHIFT, T, Float all windows, exec, ~/.config/ml4w/scripts/ml4w-toggle-allfloat # Toggle floating for all windows of workspace
-- bind = $mainMod ALT, T, exec, ~/.config/ml4w/scripts/ml4w-toggle-float-pin                  # Toggle active window into floating + pinned mode
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- toggle split
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" })) -- Move focus left
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" })) -- Move focus right
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" })) -- Move focus up
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" })) -- Move focus down

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


hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })