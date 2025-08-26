local M = {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    build = "cargo build --release",
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      keymap = {
        -- disable default preset
        preset = "none",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        keyword = { range = "full" },
        trigger = { show_on_backspace = true },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          draw = {
            columns = {
              { "kind_icon", "kind" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
          },
          border = Mo.C.border,
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
        documentation = {
          auto_show = true,
          window = {
            border = Mo.C.border,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,EndOfBuffer:EndOfBuffer",
          },
        },
        ghost_text = {
          enabled = true,
          show_without_selection = true,
        },
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_accept = true,
        },
        window = {
          border = Mo.C.border,
          max_width = math.floor(vim.o.columns * 0.8),
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder",
          show_documentation = true,
        },
      },
      sources = {
        default = { "copilot", "lsp", "path", "snippets", "buffer", "omni" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      cmdline = {
        completion = {
          menu = {
            auto_show = true,
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = false,
            },
          },
        },
        keymap = { preset = "inherit" },
      },
      appearance = {
        kind_icons = Mo.C.icons.kinds,
      },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "BufReadPost",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
      },
    },
  },
}

return M
