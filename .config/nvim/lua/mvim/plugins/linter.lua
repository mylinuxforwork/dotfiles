return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        python = { "ruff" },
        typescript = { "eslint_d" },
        javascript = { "eslint_d" },
        vue = { "eslint_d", "stylelint" },
      },
      linters = {
        eslint_d = {
          condition = function(ctx)
            return vim.fs.find(
              { "eslint.config.js", ".eslintrc.cjs" },
              { path = ctx.filename, upward = true }
            )[1]
          end,
        },
        stylelint = {
          condition = function(ctx)
            return vim.fs.find(
              { ".stylelintrc", "stylelint.config.js", "stylelint.config.cjs" },
              { path = ctx.filename, upward = true }
            )[1]
          end,
        },
      },
    },
    config = function(_, opts)
      local M = {}

      ---@class Content
      ---@field filename string
      ---@field dirname string

      ---@class Linter:lint.Linter
      ---@field condition? fun(ctx:Content)

      local lint = require("lint")
      for name, linter in pairs(opts.linters) do
        local cfg = lint.linters[name]
        if type(linter) == "table" and type(cfg) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", cfg, linter)
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name] --[[@as Linter]]
          if not linter then
            vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
          end
          return linter
            and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)

        if #names > 0 then
          lint.try_lint(names)
        end
      end

      Mo.U.augroup("CodeLinter", {
        event = opts.events,
        command = M.debounce(100, M.lint),
      })
    end,
  },
}
