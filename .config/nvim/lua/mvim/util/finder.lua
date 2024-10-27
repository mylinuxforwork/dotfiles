---@class mvim.util.finder
local M = {}

M.symbols = {
  defualt = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "Trait",
  },
  lua = {
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "Trait",
  },
  go = {
    "Interface",
    "Struct",
    "Function",
    "Method",
  },
  markdown = false,
}

---@param buf? number
---@return string[]?
function M.get_symbols(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if M.symbols[ft] == false then
    return
  end
  return M.symbols[ft] or M.symbols.defualt
end

---https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
---@param scope "workspace" | "document"
function M.lsp_symbols(scope)
  return function()
    local symbols = M.get_symbols()
    if symbols then
      local sc = vim.deepcopy(symbols)
      table.insert(sc, 1, "All")
      vim.ui.select(sc, { prompt = "Select which symbol(" .. scope .. ")" }, function(item)
        if item then
          local items = item == "All" and symbols or { item }
          if scope == "workspace" then
            require("telescope.builtin").lsp_workspace_symbols({ symbols = items })
          else
            require("telescope.builtin").lsp_document_symbols({ symbols = items })
          end
        end
      end)
    end
  end
end

function M.config_files()
  return function()
    require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
  end
end

return M
