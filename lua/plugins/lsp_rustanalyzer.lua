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
          numThreads = 2,
          checkOnSave = true,

          -- Cargo settings
          cargo = {
            allFeatures = false, -- RAM saver
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = false,
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
