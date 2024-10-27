local M = {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▏" },
      change = { text = "▏" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▏" },
      untracked = { text = "▏" },
    },
    current_line_blame = true,
    current_line_blame_formatter = " <author>, <author_time> · <summary> ",
    preview_config = { border = Mo.C.border },
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function keymap(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- stylua: ignore start
      -- Navigation
      keymap("n", "[g", function() gs.nav_hunk('prev') end, "Prev git hunk")
      keymap("n", "]g", function () gs.nav_hunk('next') end, "Next git hunk")
      -- Actions
      keymap("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
      keymap("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      keymap("n", "<leader>gd", gs.diffthis, "Diff this")
      -- Text object
      keymap({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "Select git hunk")
    end,
  },
}

return M
