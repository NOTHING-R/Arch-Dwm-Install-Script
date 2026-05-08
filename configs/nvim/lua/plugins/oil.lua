return {
  "stevearc/oil.nvim",
  lazy = false, -- ← Important: Load it immediately
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Recommended for icons
  opts = {
    default_file_explorer = true, -- This makes :e /path and nvim . use Oil
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    { "<leader>oo", "<cmd>Oil .<cr>", desc = "Open current directory in Oil" },
  },
}
