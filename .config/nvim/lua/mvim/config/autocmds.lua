-- Works better on non-transparent backgrounds
local cursorline_exclude = { "dashboard", "neo-tree-popup" }

---@param buf number
---@return boolean
local function should_show_cursorline(buf)
  return vim.bo[buf].filetype ~= ""
    and not vim.wo.previewwindow
    and not vim.tbl_contains(cursorline_exclude, vim.bo[buf].filetype)
end

Mo.U.augroup("AutoCursorLine", {
  event = { "BufEnter", "InsertLeave" },
  command = function(args)
    vim.wo.cursorline = should_show_cursorline(args.buf)
  end,
  desc = "Hide cursor line in inactive window",
}, {
  event = { "BufLeave", "InsertEnter" },
  command = function()
    vim.wo.cursorline = false
  end,
  desc = "Show cursor line only in active window",
})

Mo.U.augroup("LastPlaceLoc", {
  event = "BufReadPost",
  command = function(args)
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

Mo.U.augroup("CloseWithQ", {
  event = "FileType",
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
  command = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
  desc = "Close certain filetypes by pressing <q>",
})

Mo.U.augroup("TextYankHighlight", {
  event = { "TextYankPost" },
  command = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight on yank",
})

Mo.U.augroup("Checktime", {
  event = { "FocusGained", "TermClose", "TermLeave" },
  command = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd.checktime()
    end
  end,
  desc = "Check if we need to reload the file when it changed",
})
