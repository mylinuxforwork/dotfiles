local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "Avante" },
  keys = {
    { "<leader>mr", "<Cmd>RenderMarkdown toggle<CR>", desc = "Toggle render markdown" },
  },
  opts = {
    heading = { enabled = false },
    file_types = { "markdown", "Avante" },
    code = {
      sign = false,
      width = "block",
      position = "right",
      min_width = 60,
      left_pad = 2,
      right_pad = 2,
      inline_pad = 1,
      language_pad = 1,
    },
    pipe_table = {
      preset = "round",
    },
  },
}

return M
