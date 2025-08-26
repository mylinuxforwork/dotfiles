---@class mvim.util.exporter
local M = {}

-- Find files or live grep in the directory where the cursor is located
-- Or in the directory where the file under the cursor is located
---@param action "files" | "grep"
function M.files_or_grep(action, state)
  if Mo.U.has("snacks.nvim") then
    local node = state.tree:get_node()
    local path = node.type == "file" and node:get_parent_id() or node:get_id()

    Snacks.picker[action]({
      cwd = path,
      dirs = { path },
      format = "file",
      finder = action,
      supports_live = true,
    })
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
