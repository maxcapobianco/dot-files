return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Find plugin files
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      -- Grep in plugin directory
      {
        "<leader>fP",
        function()
          require("telescope.builtin").live_grep({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Grep Plugin Files",
      },
      -- Find files in current buffer's directory
      {
        "<leader>fb",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Find Files (Buffer Dir)",
      },
      -- Grep in current buffer's directory
      {
        "<leader>fB",
        function()
          require("telescope.builtin").live_grep({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Grep (Buffer Dir)",
      },
      -- Interactive directory picker for grep
      {
        "<leader>fD",
        function()
          local function select_dir_and_grep()
            require("telescope.builtin").find_files({
              prompt_title = "Select Directory",
              find_command = { "fdfind", "--type", "d", "--hidden", "--exclude", ".git" }, -- Changed fd to fdfind
              attach_mappings = function(prompt_bufnr, map)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")

                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  if selection then
                    require("telescope.builtin").live_grep({
                      cwd = selection.path,
                      prompt_title = "Grep in " .. vim.fn.fnamemodify(selection.path, ":~:."),
                    })
                  end
                end)
                return true
              end,
            })
          end
          select_dir_and_grep()
        end,
        desc = "Grep in Selected Directory",
      },
      -- Grep in Cargo workspace members (Rust specific)
      {
        "<leader>fR",
        function()
          local function find_cargo_root()
            return require("lspconfig.util").root_pattern("Cargo.toml")(vim.fn.getcwd())
          end

          local cargo_root = find_cargo_root()
          if cargo_root then
            require("telescope.builtin").live_grep({
              cwd = cargo_root,
              prompt_title = "Grep Cargo Workspace",
            })
          else
            vim.notify("Not in a Cargo workspace", vim.log.levels.WARN)
          end
        end,
        desc = "Grep Cargo Workspace",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        sorting_strategy = "ascending",
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "target/",
          "dist/",
          "build/",
        },
      },
      pickers = {
        find_files = {
          hidden = true, -- Show hidden files
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" } -- Grep hidden files
          end,
        },
      },
    },
  },
}
