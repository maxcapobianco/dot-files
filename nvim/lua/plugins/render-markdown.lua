return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "norg", "org", "codecompanion" },
    keys = {
      {
        "<leader>um",
        function()
          require("render-markdown").toggle()
        end,
        desc = "Toggle Markdown Rendering",
      },
    },
    opts = {
      heading = {
        enabled = true,
        icons = { "◉ ", "○ ", "◆ ", "◇ ", "★ ", "☆ " },
      },
      code = {
        enabled = true,
        style = "full",
        right_pad = 2,
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
      },
      pipe_table = {
        enabled = true,
        style = "full",
      },
    },
  },
}
