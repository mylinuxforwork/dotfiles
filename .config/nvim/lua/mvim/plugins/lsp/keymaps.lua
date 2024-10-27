local M = {}

M._keys = nil

function M.get()
  if not M._keys then
    -- stylua: ignore
    M._keys = {
      { "gd", "<CMD>Telescope lsp_definitions<CR>", desc = "Goto Definition", deps = "textDocument/definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", deps = "textDocument/declaration" },
      { "gr", "<CMD>Telescope lsp_references<CR>", desc = "References", deps = "textDocument/references" },
      { "gi", "<CMD>Telescope lsp_implementations<CR>", desc = "Goto Implementation", deps = "textDocument/implementation" },
      { "gt", "<CMD>Telescope lsp_type_definitions<CR>", desc = "Goto Type Definition", deps = "textDocument/definition" },
      { "K", vim.lsp.buf.hover, desc = "Hover", deps = "textDocument/hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", deps = "textDocument/signatureHelp" },
      { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", deps = "textDocument/signatureHelp" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", deps = "textDocument/rename"  },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" }, deps = "textDocument/codeAction" },
      { "<leader>cA", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source" }, diagnostics = {}}}) end, desc = "Source Action", desp = "textDocument/codeAction" },
    }
  end
  return M._keys
end

---@param client vim.lsp.Client
---@param buffer number
function M.on_attach(client, buffer)
  vim.iter(M.get()):each(function(m)
    if not m.deps or client.supports_method(m.deps) then
      local opts = { silent = true, buffer = buffer, desc = m.desc }
      vim.keymap.set(m.mode or "n", m[1], m[2], opts)
    end
  end)
end

return M
