local M = {
  "folke/snacks.nvim",
  -- stylua: ignore
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>fc", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fl", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undotree" },
  },
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
        buffers = { layout = "select" },
        grep_buffers = { layout = "ivy" },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<C-e>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
            ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<C-p>"] = { "history_back", mode = { "i", "n" } },
            ["<C-n>"] = { "history_forward", mode = { "i", "n" } },
          },
        },
        preview = {
          wo = {
            -- number = false,
            signcolumn = "no",
            -- relativenumber = false,
          },
        },
      },
      layouts = {
        default = {
          layout = {
            box = "horizontal",
            width = 0.9,
            min_width = 120,
            height = 0.9,
            {
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
            { win = "preview", title = "{preview}", border = "rounded", width = 0.6 },
          },
        },
      },
      icons = {
        kinds = Mo.C.icons.kinds,
        diagnostics = Mo.C.icons.diagnostics,
      },
    },
  },
}

return M
