local M = {}

--- @param client vim.lsp.Client
--- @param buffer number
function M.on_attach(client, buffer)
  if client:supports_method("textDocument/codeLens") then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = buffer,
      callback = vim.lsp.codelens.refresh,
    })
  end
end

return M
