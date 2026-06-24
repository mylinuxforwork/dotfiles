--    __  _____  _____      __  ____  ____
--   /  |/  / / / / / | /| / / / __ \/ __/
--  / /|_/ / /_/_  _/ |/ |/ / / /_/ /\ \  
-- /_/  /_/____//_/ |__/|__/  \____/___/
--   
-- Advanced configuration for Hyprland

-- FUNCTIONS
require("functions")

-- MONITORS
require("conf.monitor")
require("monitors")

-- INPUT
require("input")

-- GESTURE
require("gestures")

-- AUTOSTART
require("conf.autostart")

-- COLORS
require("colors")

-- CONFIGURATION
require("conf.environment")
require("conf.window")
require("conf.decoration")
require("conf.layout")
require("conf.workspace")
require("conf.misc")
require("conf.keybinding")
require("conf.windowrule")
require("conf.animation")
require("conf.ml4w")

-- CUSTOM
local f = io.open(os.getenv("HOME") .. "/.config/hypr/custom.lua", "r")
if f then
    f:close()
    require("custom")
end

-- HYPRMOD
require("hyprland-gui")
