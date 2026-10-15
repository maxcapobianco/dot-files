-- Editable quickfix list. Workflow with Telescope:
-- run a picker (e.g. live_grep), press <C-q> to send results to quickfix,
-- edit lines right in the quickfix buffer, then :w to apply across files.
return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  keys = {
    {
      "<leader>xq",
      function()
        require("quicker").toggle()
      end,
      desc = "Toggle Quickfix (quicker)",
    },
  },
  opts = {
    keys = {
      {
        ">",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
  },
}
