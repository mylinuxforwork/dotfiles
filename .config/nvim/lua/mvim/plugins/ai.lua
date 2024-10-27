local M = {}

---@param kind string
function M.pick(kind)
  return function()
    local actions = require("CopilotChat.actions")
    local items = actions[kind .. "_actions"]()
    if not items then
      vim.notify("No " .. kind .. " found on the current line", vim.log.levels.WARN)
      return
    end
    require("CopilotChat.integrations.telescope").pick(items)
  end
end

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        insert_at_end = true,
        question_header = "   " .. user .. " ",
        answer_header = "   Copilot ",
        window = { width = 0.4 },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
        mappings = {
          complete = {
            insert = "",
          },
          reset = {
            normal = "<C-e>",
            insert = "<C-e>",
          },
          submit_prompt = {
            normal = "<CR>",
            insert = "<C-CR>",
          },
        },
      }
    end,
    keys = {
      {
        "<leader>ai",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat",
        mode = { "n", "v" },
      },
      { "<leader>ad", M.pick("help"), desc = "Diagnostic Help", mode = { "n", "v" } },
      { "<leader>ap", M.pick("prompt"), desc = "Prompt Actions", mode = { "n", "v" } },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "copilot-chat", "copilot-help" },
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })

      chat.setup(opts)
    end,
  },
}
