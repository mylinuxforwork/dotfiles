local M = {
  "nvim-treesitter/nvim-treesitter",
  main = "nvim-treesitter.configs",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdateSync" },
  init = function(plugin)
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects" },
  },
  opts = {
    ensure_installed = {
      "bash",
      "css",
      "dockerfile",
      "dot",
      "gitignore",
      "go",
      "gomod",
      "gowork",
      "gosum",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "ron",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-CR>", -- normal mode
        scope_incremental = false, -- visual mode
        node_incremental = "<Tab>", -- visual mode
        node_decremental = "<BS>", -- visual mode
      },
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["ac"] = { query = "@function.outer", desc = "TS: all class" },
          ["ic"] = { query = "@function.inner", desc = "TS: inner class" },
          ["af"] = { query = "@function.outer", desc = "TS: all function" },
          ["if"] = { query = "@function.inner", desc = "TS: inner function" },
        },
      },
      move = {
        enable = true,
        goto_next_start = {
          ["]c"] = { query = "@class.outer", desc = "TS: Next class start" },
          ["]f"] = { query = "@function.outer", desc = "TS: Next function start" },
        },
        goto_previous_start = {
          ["[c"] = { query = "@class.outer", desc = "TS: Prev class start" },
          ["[f"] = { query = "@function.outer", desc = "TS: Prev function start" },
        },
      },
    },
  },
}

return M
