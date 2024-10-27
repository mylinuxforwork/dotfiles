local M = {}

local function highlight_references()
  local status_ok, ts_utils = pcall(function()
    return require("nvim-treesitter.ts_utils")
  end)
  if status_ok then
    local node = ts_utils.get_node_at_cursor()
    while node ~= nil do
      local node_type = node:type()
      if
        node_type == "string"
        or node_type == "string_fragment"
        or node_type == "template_string"
        or node_type == "document"
      then
        return
      end
      node = node:parent()
    end
  end
  vim.lsp.buf.document_highlight()
end

---@param client vim.lsp.Client
---@param buffer number
function M.on_attach(client, buffer)
  if client.supports_method("textDocument/documentHighlight") then
    Mo.U.augroup(("LspHighlight:%d"):format(buffer), {
      event = { "CursorHold", "CursorHoldI" },
      buffer = buffer,
      desc = "document highlight",
      command = function()
        vim.lsp.buf.document_highlight()
      end,
    }, {
      event = { "CursorMoved", "CursorMovedI" },
      buffer = buffer,
      desc = "clear highlight",
      command = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
end

return M
