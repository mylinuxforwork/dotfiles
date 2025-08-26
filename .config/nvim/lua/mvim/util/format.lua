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
  -- M.info()
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

  local lines = {
    ("- [%s] `global` %s"):format(gaf and "x" or " ", gaf and "enabled" or "disabled"),
    ("- [%s] `buffer` %s"):format(
      enabled and "x" or " ",
      baf == nil and "inherit" or baf and "enabled" or "disabled"
    ),
  }

  local level = enabled and levels.INFO or levels.WARN

  vim.notify(table.concat(lines, "\n"), level, { title = "Format" })
end

---@param opts? {force?:boolean, buf?:number}
function M.format(opts)
  opts = opts or {}

  local buf = opts.buf or vim.api.nvim_get_current_buf()
  if not ((opts and opts.force) or M.enabled(buf)) then
    return
  end

  if M.formatter == nil then
    vim.notify("**No formatter set**", levels.ERROR)
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
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("code_format", {}),
    callback = function(args)
      M.format({ buf = args.buf })
    end,
    desc = "code format",
  })

  vim.api.nvim_create_user_command("CodeFormat", function()
    M.format({ force = true })
  end, { desc = "Format selection or buffer" })

  vim.api.nvim_create_user_command("AutoFormatInfo", function()
    M.info()
  end, { desc = "Auto format info" })
end

---@param buf? boolean
function M.snacks_toggle(buf)
  return Snacks.toggle({
    name = "Auto Format (" .. (buf and "Buffer" or "Global") .. ")",
    get = function()
      if not buf then
        return vim.g.autoformat == nil or vim.g.autoformat
      end
      return Mo.U.format.enabled()
    end,
    set = function(state)
      Mo.U.format.enable(state, buf)
    end,
  })
end

return M
