-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.editorconfig = true
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Force telescope as the picker. Without this, LazyVim's "auto" picker
-- selection (the default) can resolve to fzf-lua instead -- which is
-- disabled in lua/plugins/fzf-lua.lua -- and rebind gd/gr/gI/gy to
-- `:FzfLua ...` commands that don't exist, breaking goto-definition/
-- references with "E492: Not an editor command: FzfLua ...".
vim.g.lazyvim_picker = "telescope"

-- Make root-based pickers (<leader>ff, <leader>/, etc.) search from the
-- directory nvim was launched in, instead of the current buffer's LSP root
vim.g.root_spec = { "cwd" }
