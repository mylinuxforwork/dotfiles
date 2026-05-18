local name = "default.lua"
local variant = "keybindings"
name = name:gsub(".lua", "")
require("conf." .. variant .. "." .. name)