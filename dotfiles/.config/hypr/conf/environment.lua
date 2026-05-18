local name = "default.lua"
local variant = "environments"
name = name:gsub(".lua", "")
require("conf." .. variant .. "." .. name)