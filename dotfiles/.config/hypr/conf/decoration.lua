local name = "default.lua"
local variant = "decorations"
name = name:gsub(".lua", "")
require("conf." .. variant .. "." .. name)