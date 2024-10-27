---@class mvim.config: mvim.options
local M = {}

---@type CtpColors<string> | CtpColor
M.palette = {}

---@class mvim.options
local defaults = {
  transparent = true,
  -- stylua: ignore
  icons = {
    diagnostics = {
      error = " ",
      warn  = " ",
      info  = " ",
      hint  = " ",
    },
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Color         = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Keyword       = " ",
      Method        = " ",
      Module        = " ",
      Namespace     = " ",
      Null          = "󰟢 ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = " ",
      String        = " ",
      Struct        = " ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = " ",
      Copilot       = " ",
    },
  },
}

defaults.border = defaults.transparent and "rounded" or "none"

function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.uv.fs_stat(lazypath) then
    local output = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
    if vim.api.nvim_get_vvar("shell_error") ~= 0 then
      vim.api.nvim_err_writeln("Error cloning lazy.nvim repository...\n\n" .. output)
    end
  end
  vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

  require("lazy").setup({
    spec = "mvim.plugins",
    defaults = { lazy = true },
    install = { colorscheme = { "catppuccin" } },
    change_detection = { notify = false },
    rocks = { enabled = false },
    ui = {
      backdrop = M.transparent and 100 or 60,
      border = M.border,
      icons = {
        loaded = "󰽢",
        not_loaded = "󰏝",
        plugin = "",
      },
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "tohtml",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "matchit",
          "tar",
          "tarPlugin",
          "rrhelper",
          "spellfile_plugin",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
          "tutor",
          "rplugin",
          "syntax",
          "synmenu",
          "optwin",
          "compiler",
          "bugreport",
        },
      },
    },
  })
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function _load(mod)
    local U = require("lazy.core.util")

    U.try(function()
      require(mod)
    end, {
      msg = "Failed loading " .. mod,
      on_error = function(msg)
        local info = require("lazy.core.cache").find(mod)
        if info == nil or (type(info) == "table" and #info == 0) then
          return
        end
        U.error(msg)
      end,
    })
  end

  _load("mvim.config." .. name)

  if vim.bo.filetype == "lazy" then
    vim.cmd([[do VimResized]])
  end
end

M.did_init = false
function M.init()
  if not M.did_init then
    M.did_init = true

    M.load("options")
  end
end

function M.setup()
  M.bootstrap()

  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end

  Mo.U.augroup("NeovimPDE", {
    pattern = "VeryLazy",
    event = "User",
    command = function()
      if lazy_autocmds then
        M.load("autocmds")
      end
      M.load("keymaps")

      Mo.U.format.setup()
    end,
  })
end

---@param palette CtpColors<string> | CtpColor
function M.filling_pigments(palette)
  M.palette = palette
end

setmetatable(M, {
  __index = function(_, key)
    return defaults[key]
  end,
})

return M
