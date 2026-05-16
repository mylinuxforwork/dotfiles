name = "default.lua"
name = name:gsub(".lua", "")
require("conf.decorations." .. name)