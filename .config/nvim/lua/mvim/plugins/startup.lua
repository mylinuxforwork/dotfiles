local M = {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function()
    local banner = [[
      .-') _     ('-.                      (`-.              _   .-')      
      ( OO ) )  _(  OO)                   _(OO  )_           ( '.( OO )_    
  ,--./ ,--,'  (,------.  .-'),-----. ,--(_/   ,. \  ,-.-')   ,--.   ,--.)  
  |   \ |  |\   |  .---' ( OO'  .-.  '\   \   /(__/  |  |OO)  |   `.'   |   
  |    \|  | )  |  |     /   |  | |  | \   \ /   /   |  |  \  |         |   
  |  .     |/  (|  '--.  \_) |  |\|  |  \   '   /,   |  |(_/  |  |'.'|  |   
  |  |\    |    |  .--'    \ |  | |  |   \     /__) ,|  |_.'  |  |   |  |   
  |  | \   |    |  `---.    `'  '-'  '    \   /    (_|  |     |  |   |  |   
  `--'  `--'    `------'      `-----'      `-'       `--'     `--'   `--'   
    ]]
    banner = string.rep("\n", 7) .. banner .. "\n"
    local opts = {
      theme = "doom",
      hide = {
        statusline = false,
        tabline = false,
        winbar = false,
      },
      config = {
        header = vim.split(banner, "\n"),
        -- stylua: ignore
        center = {
          { action = "ene | startinsert",     desc = " New file",     icon = " ", key = "n", icon_hl = "Character" },
          { action = "Telescope find_files",  desc = " Find file",    icon = " ", key = "f", icon_hl = "Label" },
          { action = "Telescope live_grep",   desc = " Find text",    icon = " ", key = "g", icon_hl = "Special" },
          { action = "Telescope oldfiles",    desc = " Recent files", icon = " ", key = "r", icon_hl = "Macro" },
          { action = "qa",                    desc = " Quit",         icon = " ", key = "q", icon_hl = "Error" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          local version = vim.version()

          return {
            string.format(
              " Neovim v%d.%d.%d%s",
              version.major,
              version.minor,
              version.patch,
              version.prerelease and "(nightly)" or ""
            ) .. " loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
          }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.key_format = "%s"
      button.key_hl = "Constant"
      button.desc_hl = "CursorLineNr"
      button.desc = button.desc .. string.rep(" ", 50 - #button.desc)
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
}

return M
