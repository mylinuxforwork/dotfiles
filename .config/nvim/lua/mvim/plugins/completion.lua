local function has_words_before()
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local M = {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "copilot.lua",
        opts = {},
      },
    },
    config = function()
      local cmp, luasnip = require("cmp"), require("luasnip")
      local select = cmp.SelectBehavior.Select

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        experimental = { ghost_text = true },
        window = {
          completion = {
            border = Mo.C.border,
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          },
          documentation = {
            border = Mo.C.border,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        view = {
          entries = {
            name = "custom",
            follow_cursor = true,
          },
        },
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
            keyword_length = 2,
          },
        }),
        formatting = {
          expandable_indicator = false,
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local icons = Mo.C.icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            if entry.source.name ~= "copilot" then
              local widths = { abbr = 27, menu = 35 }
              for key, value in pairs(widths) do
                if item[key] and vim.fn.strchars(item[key]) > value then
                  item[key] = vim.fn.strcharpart(item[key], 0, value - 3) .. "..."
                end
              end
            end
            return item
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = select })
            -- elseif vim.snippet.active({ direction = 1 }) then
            --   vim.schedule(function()
            --     vim.snippet.jump(1)
            --   end)
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = select })
            -- elseif vim.snippet.active({ direction = -1 }) then
            --   vim.schedule(function()
            --     vim.snippet.jump(-1)
            --   end)
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
          ["<C-e>"] = { i = cmp.mapping.abort(), c = cmp.mapping.close() },
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          -- stylua: ignore
          ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = select }), { "i", "c" }),
          ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = select }), { "i", "c" }),
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "cmdline" },
        },
      })
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    lazy = true,
    keys = {
      {
        "<C-o>",
        function()
          if require("luasnip").choice_active() then
            require("luasnip").change_choice(1)
          end
        end,
        mode = { "s", "i" },
        desc = "Select option",
      },
    },
    config = function()
      require("luasnip").setup({
        ext_opts = {
          [require("luasnip.util.types").choiceNode] = {
            active = {
              virt_text = {
                { "󰠖 ", "Type" },
              },
            },
          },
        },
      })

      require("luasnip.loaders.from_vscode").lazy_load({
        paths = vim.fn.stdpath("config") .. "/snippets",
      })

      Mo.U.augroup("UnlinkSnippetOnModeChange", {
        event = "ModeChanged",
        pattern = { "s:n", "i:*" },
        command = function(args)
          if
            require("luasnip").session.current_nodes[args.buf]
            and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end,
        desc = "Forget the current snippet when leaving the insert mode",
      })
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
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
