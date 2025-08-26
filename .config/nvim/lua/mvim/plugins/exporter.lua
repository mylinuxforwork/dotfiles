local M = {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    {
      "<C-n>",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true })
      end,
      desc = "Explorer(NeoTree)",
    },
  },
  init = function()
    if vim.fn.argc(-1) == 1 then
      local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
  opts = function()
    local events = require("neo-tree.events")
    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end

    return {
      source_selector = {
        winbar = true,
        separator = "",
        content_layout = "center",
        truncation_character = "",
        sources = {
          { source = "filesystem", display_name = "󱉭 Files" },
          { source = "buffers", display_name = " Buffers" },
          { source = "git_status", display_name = "󰊢 Git" },
        },
      },
      close_if_last_window = true,
      use_default_mappings = false,
      popup_border_style = "rounded", -- no support "none"
      event_handlers = {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      },
      default_component_configs = {
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󰉖",
          folder_empty_open = "󰷏",
          default = "󰡯",
        },
        modified = { symbol = "●" },
        name = {
          trailing_slash = false,
          highlight_opened_files = true,
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            added = "󰐖 ", -- " "
            modified = "󱗜 ", --  " "
            deleted = "󰍵 ", -- " "
            renamed = "󰜵 ", -- " "
            ignored = "󰿠 ", -- " "

            untracked = "󰩳 ", -- " "
            unstaged = "󰆟 ", -- " " --󰄱 󰙀 󰔌
            staged = "󰄲 ", -- " "
            conflict = "󰅗 ", -- 
          },
        },
      },
      commands = {
        copy_filename = function(state)
          Mo.U.exporter.copy("filename", state)
        end,
        copy_path = function(state)
          Mo.U.exporter.copy("path", state)
        end,
      },
      window = {
        position = "right",
        width = 42,
        mappings = {
          ["l"] = "open",
          ["L"] = "open",
          ["<CR>"] = "open",
          ["<2-LeftMouse>"] = "open",

          ["h"] = "close_node",

          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["F"] = "focus_preview",
          ["<Esc>"] = "cancel",

          ["|"] = "open_vsplit",
          ["-"] = "open_split",

          ["R"] = "refresh",
          ["a"] = { "add", config = { show_path = "relative", insert_as = "sibling" } },
          ["A"] = { "add", config = { show_path = "relative", insert_as = "child" } },
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",

          ["cf"] = "copy_filename",
          ["cp"] = "copy_path",

          ["[b"] = "prev_source",
          ["]b"] = "next_source",

          ["z"] = "close_all_nodes",
          ["Z"] = "expand_all_nodes",

          ["<C-d>"] = { "scroll_preview", config = { direction = -4 } },
          ["<C-u>"] = { "scroll_preview", config = { direction = 4 } },

          ["e"] = "toggle_auto_expand_width",
          ["q"] = "close_window",
          ["?"] = "show_help",
        },
      },
      filesystem = {
        window = {
          mappings = {
            ["."] = "toggle_hidden",

            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            ["#"] = "fuzzy_sorter",

            -- ["f"] = "filter_on_submit",
            -- ["F"] = "clear_filter",

            ["<BS>"] = "navigate_up",
            -- ["."] = "set_root",

            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
          },
        },
        filtered_items = {
          visible = true,
        },
        bind_to_cwd = false,
        use_libuv_file_watcher = true,
        follow_current_file = { enabled = true },
      },
    }
  end,
  config = function(_, opts)
    require("neo-tree").setup(opts)
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}

return M
