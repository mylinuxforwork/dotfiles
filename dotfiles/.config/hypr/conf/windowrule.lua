local name = "default.lua"
local variant = "windowrules"
name = name:gsub(".lua", "")
require("conf." .. variant .. "." .. name)