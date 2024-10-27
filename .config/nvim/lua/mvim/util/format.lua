local levels = vim.log.levels

---@class mvim.util.format
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.format(...)
  end,
})

---@class Formatter
---@field name string
---@field format fun(buf:number)

---@type Formatter
M.formatter = nil

---@param buf? number
function M.enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  -- If the buffer has a local value, use that
  if baf ~= nil then
    return baf
  end

  -- Otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

---@param enable? boolean
---@param buf? boolean
function M.enable(enable, buf)
  if enable == nil then
    enable = true
  end
  if buf then
    vim.b.autoformat = enable
  else
    vim.g.autoformat = enable
    vim.b.autoformat = nil
  end
  M.info()
end

---@param buf? boolean
function M.toggle(buf)
  M.enable(not M.enabled(), buf)
end

---@param buf? number
function M.info(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local gaf = vim.g.autoformat == nil or vim.g.autoformat
  local baf = vim.b[buf].autoformat
  local enabled = M.enabled(buf)

  local msg = ("Format: %s [[ global:%s | buffer:%s ]]"):format(
    enabled and "enabled" or "disabled",
    gaf and "enabled" or "disabled",
    baf == nil and "inherit" or baf and "enabled" or "disabled"
  )
  local level = enabled and levels.INFO or levels.WARN

  vim.notify(msg, level)
end

---@param opts? {force?:boolean, buf?:number}
function M.format(opts)
  opts = opts or {}

  local buf = opts.buf or vim.api.nvim_get_current_buf()
  if not ((opts and opts.force) or M.enabled(buf)) then
    return
  end

  xpcall(function()
    M.formatter.format(buf)
  end, function(err)
    -- local msg = debug.traceback(err)
    vim.schedule(function()
      vim.notify("Code Format Error: " .. err, levels.ERROR)
    end)
  end)
end

function M.setup()
  Mo.U.augroup("CodeFormat", {
    event = "BufWritePre",
    pattern = "*",
    command = function(args)
      M.format({ buf = args.buf })
    end,
    desc = "Code format",
  })

  vim.api.nvim_create_user_command("CodeFormat", function()
    M.format({ force = true })
  end, { desc = "Code format" })
end

return M
