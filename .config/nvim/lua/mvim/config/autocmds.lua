local function augroup(name)
  return vim.api.nvim_create_augroup("mvim_pde_" .. name, { clear = true })
end

-- Works better on non-transparent backgrounds
local cursorline_exclude = { "neo-tree-popup", "snacks_dashboard", "snacks_picker_input" }

---@param buf number
---@return boolean
local function should_show_cursorline(buf)
  return vim.bo[buf].filetype ~= ""
    and not vim.wo.previewwindow
    and not vim.tbl_contains(cursorline_exclude, vim.bo[buf].filetype)
end

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
  callback = function(args)
    vim.wo.cursorline = should_show_cursorline(args.buf)
  end,
  desc = "Show cursor line only in active window",
})

vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
  callback = function()
    vim.wo.cursorline = false
  end,
  desc = "Hide cursorline in inactive window",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(args)
    local exclude = { "gitcommit" }
    local buf = args.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazy_last_loc then
      return
    end
    vim.b[buf].lazy_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last loc when opening a buffer",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "qf",
    "help",
    "query",
    "checkhealth",
    "neotest-output",
    "neotest-attach",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
      end, {
        buffer = args.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
  desc = "Close certain filetypes by pressing <q>",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd.checktime()
    end
  end,
  desc = "Check if we need to reload the file when it changed",
})
