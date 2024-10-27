---@class Mo
---@field C mvim.config
---@field U mvim.util
local ns = {}

local function load_module(key)
  if key == "C" then
    return require("mvim.config")
  elseif key == "U" then
    return require("mvim.util")
  end
end

Mo = setmetatable(ns, {
  __index = function(t, key)
    local module = load_module(key)
    if module then
      rawset(t, key, module)
    end
    return module
  end,
})

Mo.C.setup()
