local M = {
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<leader>bp", "<Cmd>BufferLinePick<CR>", desc = "Buffer pick" },
      { "<leader>bc", "<Cmd>BufferLinePickClose<CR>", desc = "Pick close" },
      { "<leader>b[", "<Cmd>BufferLineMovePrev<CR>", desc = "Move prev" },
      { "<leader>b]", "<Cmd>BufferLineMoveNext<CR>", desc = "Move next" },
      { "<leader>bH", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close to the left" },
      { "<leader>bL", "<Cmd>BufferLineCloseRight<CR>", desc = "Close to the right" },
    },
    opts = function()
      local ctp = require("catppuccin.groups.integrations.bufferline")

      return {
        options = {
          indicator = { icon = "▍", style = "icon" },
          buffer_close_icon = "󰖭",
          modified_icon = "●",
          left_trunc_marker = " ",
          right_trunc_marker = " ",
          right_mouse_command = false,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, level)
            level = level:match("warn") and "warn" or level
            return Mo.C.icons.diagnostics[level] or ""
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              separator = Mo.C.transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "Avante",
              separator = Mo.C.transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "dapui_scopes",
              text = "Debugger",
              separator = Mo.C.transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
          },
          move_wraps_at_ends = true,
          show_close_icon = false,
          separator_style = Mo.C.transparent and "thin" or "slope",
          show_buffer_close_icons = false,
          sort_by = "insert_after_current",
        },
        highlights = ctp.get({
          custom = {
            all = {
              buffer_selected = { fg = Mo.C.palette.lavender },

              error = { fg = Mo.C.palette.surface1 },
              error_diagnostic = { fg = Mo.C.palette.surface1 },

              warning = { fg = Mo.C.palette.surface1 },
              warning_diagnostic = { fg = Mo.C.palette.surface1 },

              info = { fg = Mo.C.palette.surface1 },
              info_diagnostic = { fg = Mo.C.palette.surface1 },

              hint = { fg = Mo.C.palette.surface1 },
              hint_diagnostic = { fg = Mo.C.palette.surface1 },
            },
          },
        }),
      }
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = { "BufNewFile", "BufReadPost" },
    opts = function()
      return {
        options = {
          theme = "catppuccin",
          component_separators = "",
          section_separators = "",
          disabled_filetypes = {
            statusline = { "dashboard" },
          },
          globalstatus = true,
        },
        sections = {
          lualine_a = { Mo.U.lualine.components.mode },
          lualine_b = { Mo.U.lualine.components.branch },
          lualine_c = {
            Mo.U.lualine.components.diff,
            Mo.U.lualine.components.diagnostics,
          },
          lualine_x = {
            Mo.U.lualine.components.copilot,
            Mo.U.lualine.components.dap,
            -- lualine.components.lsp,
            -- lualine.components.treesitter,
            Mo.U.lualine.components.spaces,
            Mo.U.lualine.components.filesize,
            -- lualine.components.lazy,
          },
          lualine_y = { Mo.U.lualine.components.location },
          lualine_z = { Mo.U.lualine.components.scrollbar },
        },
      }
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<C-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-d>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll down",
        mode = { "i", "n", "s" },
      },
      {
        "<C-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-u>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll up",
        mode = { "i", "n", "s" },
      },
    },
    opts = {
      cmdline = { view = "cmdline" },
      lsp = {
        signature = { enabled = false },
        documentation = {
          opts = {
            size = {
              max_height = 15,
              max_width = math.floor(vim.o.columns * 0.8),
            },
          },
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d+ fewer lines" },
              { find = "^Hunk %d+ of %d" },
              { find = "^No hunks" },
              { find = "^E486" },
              { find = "%d+ more lines" },
              { find = "%d+ lines yanked" },
            },
          },
          view = "mini",
        },
        {
          opts = { skip = true },
          filter = {
            event = "msg_show",
            any = {
              { find = "search hit %w+, continuing at %w+" },
            },
          },
        },
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        lsp_doc_border = Mo.C.transparent,
      },
    },
    config = function(_, opts)
      -- if vim.o.filetype == "lazy" then
      --   vim.cmd([[ message clear]])
      -- end
      require("noice").setup(opts)
    end,
  },
}

return M
