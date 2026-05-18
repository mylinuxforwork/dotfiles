local name = "default.lua"
local variant = "workspaces"
name = name:gsub(".lua", "")
require("conf." .. variant .. "." .. name)