local name = "default.lua"
local variant = "animations"
name = name:gsub(".lua", "")
require("conf." .. variant .. "." .. name)