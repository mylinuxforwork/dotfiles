---@class mvim.util
---@field format mvim.util.format
---@field lsp mvim.util.lsp
---@field exporter mvim.util.exporter
---@field toggle mvim.util.toggle
---@field finder mvim.util.finder
---@field augroup mvim.util.augroup
---@field lualine mvim.util.lualine
---@field terminal mvim.util.terminal
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("mvim.util." .. k)
    return t[k]
  end,
})

---Check if the plugin exists
---@param plugin string plugin name
---@return boolean
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---Get the specified plugin opts
---@param name string plugin name
---@return table plugin_opts
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---Execute code when a plugin loads
---@param name string plugin name
---@param fn fun(name: string)
function M.on_load(name, fn)
  local Config = require("lazy.core.config")
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(args)
        if args.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

return M
