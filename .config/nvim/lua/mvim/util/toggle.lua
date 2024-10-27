---@class mvim.util.toggle
local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return vim.notify("Set " .. option .. " to " .. vim.opt_local[option]:get())
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      vim.notify("Enabled " .. option)
    else
      vim.notify("Disabled " .. option, vim.log.levels.WARN)
    end
  end
end

---@param buf? number
---@param value? boolean
function M.inlay_hints(buf, value)
  if value == nil then
    value = not vim.lsp.inlay_hint.is_enabled({ bufnr = buf or 0 })
  end
  vim.lsp.inlay_hint.enable(value, { bufnr = buf })
end

setmetatable(M, {
  __call = function(m, ...)
    return m.option(...)
  end,
})

return M
