local M = {}

-- stylua: ignore
M.keys = {
  { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
  { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition"  },
  { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },

  { "grr", function() Snacks.picker.lsp_references() end, desc = "References" },
  { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
  { "grn", vim.lsp.buf.rename, desc = "Rename" },
  { "gra", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" } },

  { "K", function() vim.lsp.buf.hover() end, desc = "Hover" },
  -- { "gK", function() vim.lsp.buf.signature_help() end, desc = "Signature Help" },
  -- { "<C-k>", function() vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help" },

  { "<leader>cc", vim.lsp.codelens.run, desc = "Codelens", mode = { "n", "v" } },
  { "<leader>cC", vim.lsp.codelens.refresh, desc = "Codelens" },

  { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
  { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
}

---@param client vim.lsp.Client
---@param buffer number
function M.on_attach(client, buffer)
  if client.name ~= "copilot" then
    vim.iter(M.keys):each(function(m)
      local opts = { silent = true, buffer = buffer, desc = m.desc }
      vim.keymap.set(m.mode or "n", m[1], m[2], opts)
    end)
  end
end

return M
