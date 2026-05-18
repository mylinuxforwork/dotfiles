local name = "default.lua"
local variant = "windows"
name = name:gsub(".lua", "")
require("conf." .. variant .. "." .. name)