return {
  {
    "mrcjkb/rustaceanvim",
    opts = function(_, opts)
      opts.server = opts.server or {}
      opts.server.default_settings = {
        ["rust-analyzer"] = {
          -- Performance settings
          cachePriming = {
            enable = false,
          },
          -- numThreads left unset so rust-analyzer sizes its thread pool to
          -- available cores itself; capping it to 2 was starving request
          -- handling (goto-def/references) whenever a background check/index
          -- was running, which is why navigation appeared broken.
          checkOnSave = true,

          procMacro = {
            enable = true, -- or true with limited attributes
          },

          check = {
            command = "clippy", -- "clippy" is heavier
            workspace = false, -- only check the crate you're editing, not the whole workspace
          },

          workspace = {
            symbol = {
              search = {
                limit = 128, -- default is 128, lower if needed
              },
            },
          },

          -- Cargo settings
          cargo = {
            allFeatures = false, -- RAM saver
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true, -- needed for accurate proc-macro/derive resolution (serde, tokio, etc.)
            },
            extraEnv = {
              -- keep rust-analyzer's own build/check artifacts out of your normal
              -- `cargo build`/`cargo test` target dir so they stop invalidating
              -- each other's caches (a common hidden source of full rebuilds)
              CARGO_TARGET_DIR = "target/rust-analyzer",
            },
          },

          -- File exclusions
          files = {
            excludeDirs = {
              ".direnv",
              ".git",
              ".github",
              ".gitlab",
              "bin",
              "node_modules",
              "target",
              "venv",
              ".venv",
            },
          },

          -- UI features
          lens = {
            enable = true,
          },
          inlayHints = {
            enable = true,
          },
          completion = {
            postfix = {
              enable = true,
            },
          },

          -- Diagnostics
          diagnostics = {
            disabled = { "unresolved-proc-macro" },
          },
        },
      }
    end,
  },
}
