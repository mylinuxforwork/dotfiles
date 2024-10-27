return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      Mo.U.on_very_lazy(function()
        Mo.U.format.formatter = {
          name = "conform.nvim",
          format = function(buf)
            require("conform").format({ bufnr = buf })
          end,
        }
      end)
    end,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        toml = { "taplo" },
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        go = { "goimports", lsp_format = "last" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        vue = { "eslint_d", "stylelint" },
        python = { "ruff_fix", "ruff_format" },
      },
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
        eslint_d = {
          env = {
            ESLINT_USE_FLAT_CONFIG = "true",
          },
          condition = function(self, ctx)
            return vim.fs.find(
              { "eslint.config.js", ".eslintrc.cjs" },
              { path = ctx.filename, upward = true }
            )[1]
          end,
        },
        stylelint = {
          condition = function(self, ctx)
            return vim.fs.find(
              { ".stylelintrc", "stylelint.config.js", "stylelint.config.cjs" },
              { path = ctx.filename, upward = true }
            )[1]
          end,
        },
      },
    },
  },
}
