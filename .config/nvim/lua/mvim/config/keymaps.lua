local keymap = vim.keymap.set

-- Editing: write
keymap("n", "<leader>w", "<Cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>W", "<Cmd>wa<CR>", { desc = "Save files" })

-- Editing: quit
keymap("n", "<leader>q", "<Cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<Cmd>q!<CR>", { desc = "Force quit" })

-- Motion
keymap({ "n", "x" }, "H", "^", { desc = "To the first non-blank char of the line" })
keymap({ "n", "x" }, "L", "$", { desc = "To the end of the line" })

-- Move line
keymap("n", "<M-k>", "<Cmd>move .-2<CR>==", { desc = "Move up" })
keymap("n", "<M-j>", "<Cmd>move .+1<CR>==", { desc = "Move down" })
keymap("i", "<M-k>", "<Esc><Cmd>move .-2<CR>==gi", { desc = "Move up" })
keymap("i", "<M-j>", "<Esc><Cmd>move .+1<CR>==gi", { desc = "Move down" })
keymap("v", "<M-k>", ":move '<-2<cr>gv=gv", { desc = "Move up" })
keymap("v", "<M-j>", ":move '>+1<cr>gv=gv", { desc = "Move down" })

-- Split window
keymap("n", "<leader>_", "<C-w>s", { desc = "Split below" })
keymap("n", "<leader>|", "<C-w>v", { desc = "Split right" })

-- Move to window
keymap("n", "<C-h>", "<C-w>h", { remap = true, desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { remap = true, desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { remap = true, desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { remap = true, desc = "Go to right window" })

-- Resize window
keymap("n", "<Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<Left>", "<Cmd>vertical resize -2<CR>", { desc = "Increase window width" })
keymap("n", "<Right>", "<Cmd>vertical resize +2<CR>", { desc = "Decrease window width" })

-- Saner behavior of n and N
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

keymap("v", ">", ">gv", { desc = "Visual shifting" })
keymap("v", "<", "<gv", { desc = "Visual shifting" })

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<Cmd>nohlsearch<CR><Esc>", { desc = "Escape and clear hlsearch" })

-- Better up/down
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move cursor up" })
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move cursor down" })

keymap("i", "jj", [[col('.') == 1 ? '<Esc>' : '<Esc>l']], { expr = true })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
keymap("n", "<leader>cd", function()
  vim.diagnostic.open_float({ scope = "cursor", force = false })
end, { desc = "Line Diagnostic" })
keymap("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keymap("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keymap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keymap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keymap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keymap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

keymap("n", "<leader>pl", "<CMD>Lazy<CR>", { desc = "Lazy" })

-- stylua: ignore start

-- Lazygit
keymap("n", "<leader>gg", function() Mo.U.terminal({ "lazygit" }) end, { desc = "Lazygit" })

-- Code format
keymap("n", "<leader>of", function() Mo.U.format.toggle() end, { desc = "Toggle auto format(global)" })
keymap("n", "<leader>oF", function() Mo.U.format.toggle(true) end, { desc = "Toggle auto format(buffer)" })
keymap({ "n", "v" }, "<leader>cf", function() Mo.U.format.format({ force = true }) end, { desc = "Code format" })


keymap("n", "<leader>oh", function() Mo.U.toggle.inlay_hints() end, { desc = "Toggle Inlay Hints" })
keymap("n", "<leader>os", function() Mo.U.toggle("spell") end, { desc = "Toggle spelling" })

keymap("n", "<leader>ow", function() Mo.U.toggle("wrap") end, { desc = "Toggle word wrap" })
