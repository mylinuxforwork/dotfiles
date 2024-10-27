---@class mvim.util.exporter
local M = {}

-- Find files or live grep in the directory where the cursor is located
-- Or in the directory where the file under the cursor is located
---@param action "find" | "grep"
function M.find_or_grep(action, state)
  if Mo.U.has("telescope.nvim") then
    local node = state.tree:get_node()
    local path = node.type == "file" and node:get_parent_id() or node:get_id()

    local prompt = string.format(
      action == "grep" and "Live Grep in %s" or "Find Files in %s",
      require("telescope.utils").transform_path({ path_display = { "shorten" } }, path)
    )
    local func = action == "grep" and require("telescope.builtin").live_grep
      or require("telescope.builtin").find_files

    func({
      cwd = path,
      prompt_title = prompt,
      search_dirs = { path },
      attach_mappings = function(prompt_bufnr)
        local actions = require("telescope.actions")
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local action_state = require("telescope.actions.state")
          local selection = action_state.get_selected_entry()
          local filename = selection.filename
          if filename == nil then
            filename = selection[1]
          end
          require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
        end)
        return true
      end,
    })
  end
end

---@param from string
---@param to string
function M.on_renamed(from, to)
  local changes = {
    files = {
      {
        oldUri = vim.uri_from_fname(from),
        newUri = vim.uri_from_fname(to),
      },
    },
  }

  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      local resp = client.request_sync("workspace/willRenameFiles", changes, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
    if client.supports_method("workspace/didRenameFiles") then
      client.notify("workspace/didRenameFiles", changes)
    end
  end
end

---@param type "filename" | "path"
function M.copy(type, state)
  local node = state.tree:get_node()
  local target = node:get_id()
  if type == "filename" then
    target = vim.fn.fnamemodify(target, ":t")
  end
  vim.fn.setreg("+", target, "c")
  vim.notify(type .. " copied", vim.log.levels.INFO)
end
return M
