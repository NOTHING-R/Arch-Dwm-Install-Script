return {
  -- JSX/TSX syntax highlighting & tag support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "javascript",
        "typescript",
        "tsx",
        "css",
        "html",
        "json",
      })
    end,
  },

  -- Auto close/rename JSX tags (like VS Code)
  {
    "windwp/nvim-ts-autotag",
    opts = {
      options = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
  },

  -- LSP: TypeScript + JSX support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "none",
                includeInlayFunctionLikeReturnTypeHints = false, -- add this
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "none",
                includeInlayFunctionLikeReturnTypeHints = false, -- add this
              },
            },
          },
        },
        -- ts_ls = {
        --   settings = {
        --     typescript = { inlayHints = { includeInlayParameterNameHints = "none" } },
        --     javascript = { inlayHints = { includeInlayParameterNameHints = "none" } },
        --   },
        -- },
        -- CSS-in-JS and plain CSS
        cssls = {},
        -- HTML inside JSX
        html = {},
      },
    },
  },
}
