return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    build = "make tiktoken",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        insert_at_end = true,
        question_header = "   " .. user .. " ",
        answer_header = "   Copilot ",
        window = { width = 0.4 },
        mappings = {
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
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.signcolumn = "no"
          vim.opt_local.relativenumber = false
        end,
      })

      require("CopilotChat").setup(opts)
    end,
  },
  {
    "yetone/avante.nvim",
    -- enabled = false,
    -- event = "VeryLazy",
    opts = {
      provider = "azure",
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          -- endpoint = "https://api.deepseek.com",
          -- model = "deepseek-chat",
          endpoint = "https://api.siliconflow.cn",
          model = "deepseek-ai/DeepSeek-R1",
          disable_tools = true,
        },
      },
      openai = {
        endpoint = "https://openrouter.ai/api/v1",
        model = "google/gemini-2.5-pro-preview",
        timeout = 30000,
        temperature = 0,
        max_completion_tokens = 8192,
      },
      mappings = {
        submit = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
        sidebar = {
          close_from_input = { normal = { "q", "<Esc>" }, insert = "<C-e>" },
        },
      },
      windows = {
        sidebar_header = {
          rounded = false,
        },
        input = {
          prefix = "> ",
          height = 5,
        },
        edit = {
          border = "rounded",
        },
        ask = {
          start_insert = false,
        },
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
}
