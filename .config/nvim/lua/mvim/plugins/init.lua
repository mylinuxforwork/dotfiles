Mo.C.init()

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- stylua: ignore
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete Other" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
    },
    opts = {
      indent = {
        indent = { char = "┊" },
        scope = { enabled = false },
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
          },
        },
        filter = function(buf)
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
            and vim.bo[buf].filetype ~= "markdown"
        end,
      },
      scope = { enabled = true },
      notifier = {
        icons = {
          error = "",
          warn = "",
          info = "",
          debug = "",
          trace = "",
        },
      },
      lazygit = {
        configure = false,
        win = { border = Mo.C.border },
      },
      input = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { folds = { open = true, git_hl = true } },
      words = { enabled = true },
      styles = {
        notification = { wo = { wrap = true } },
        terminal = { keys = { term_normal = false } },
        input = {
          row = -3,
          col = -5,
          width = 32,
          relative = "cursor",
          title_pos = "left",
          keys = {
            i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
          },
        },
      },
      dashboard = {
        preset = {
          header = [[
      .-') _     ('-.                      (`-.              _   .-')      
      ( OO ) )  _(  OO)                   _(OO  )_           ( '.( OO )_    
  ,--./ ,--,'  (,------.  .-'),-----. ,--(_/   ,. \  ,-.-')   ,--.   ,--.)  
  |   \ |  |\   |  .---' ( OO'  .-.  '\   \   /(__/  |  |OO)  |   `.'   |   
  |    \|  | )  |  |     /   |  | |  | \   \ /   /   |  |  \  |         |   
  |  .     |/  (|  '--.  \_) |  |\|  |  \   '   /,   |  |(_/  |  |'.'|  |   
  |  |\    |    |  .--'    \ |  | |  |   \     /__) ,|  |_.'  |  |   |  |   
  |  | \   |    |  `---.    `'  '-'  '    \   /    (_|  |     |  |   |  |   
  `--'  `--'    `------'      `-----'      `-'       `--'     `--'   `--'   ]],
          keys = {
            {
              text = {
                { "  ", hl = "Character" },
                { "New File", hl = "CursorLineNr", width = 55 },
                { "n", hl = "Constant" },
              },
              key = "n",
              action = ":ene | startinsert",
            },
            {
              text = {
                { "  ", hl = "Label" },
                { "Find File", hl = "CursorLineNr", width = 55 },
                { "f", hl = "Constant" },
              },
              action = function()
                Snacks.picker.files()
              end,
              key = "f",
            },
            {
              text = {
                { "  ", hl = "Special" },
                { "Find Text", hl = "CursorLineNr", width = 55 },
                { "g", hl = "Constant" },
              },
              action = function()
                Snacks.picker.grep()
              end,
              key = "g",
            },
            {
              text = {
                { "  ", hl = "Macro" },
                { "Recent Files", hl = "CursorLineNr", width = 55 },
                { "r", hl = "Constant" },
              },
              action = function()
                Snacks.picker.recent()
              end,
              key = "r",
            },
            {
              text = {
                { "  ", hl = "Identifier" },
                { "Recent Projects", hl = "CursorLineNr", width = 55 },
                { "p", hl = "Constant" },
              },
              action = function()
                Snacks.picker.projects()
              end,
              key = "p",
            },
            {
              text = {
                { "  ", hl = "Error" },
                { "Quit", hl = "CursorLineNr", width = 55 },
                { "q", hl = "Constant" },
              },
              action = ":qa",
              key = "q",
            },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 2 },
          { section = "startup", icon = " " },
        },
      },
    },
  },
}
