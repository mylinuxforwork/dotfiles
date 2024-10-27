---@class mvim.util.augroup
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.augroup(...)
  end,
})

---@class AutocmdArgs
---@field id number
---@field event string
---@field group? string
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc? string
---@field event  string | string[] autocommand events
---@field pattern? string | string[] autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested?  boolean
---@field once?    boolean
---@field buffer?  number

---Create an autocommand
---returns the group ID so that it can be cleared or maipulated.
---@param name string The name of the autocommand group
---@param ... Autocommand A list of autocommands to create
---@return number augroup_id
function M.augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, string.format("You must specify at least on autocommand for %s", name))
  local group_id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = group_id,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return group_id
end

return M
