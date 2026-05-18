local name = "default.lua"
local variant = "monitors"
name = name:gsub(".lua", "")
require("conf." .. variant .. "." .. name)