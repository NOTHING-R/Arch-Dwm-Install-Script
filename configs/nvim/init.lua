-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugins.telescope_buffer")
require("config.toggles")
require("config.orgextra")
require("plugins.orgmode")

vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "silent! write",
})

vim.api.nvim_set_hl(0, "RenderMarkdownCodeBlock", {
  bg = "NONE",
})

vim.api.nvim_set_hl(0, "RenderMarkdownCodeBlock", {
  link = "RenderMarkdownH1",
})

vim.api.nvim_set_hl(0, "RenderMarkdownCode", {
  bg = "#1e1e2e", -- subtle dark tone (optional)
})

vim.api.nvim_set_hl(0, "CursorLine", {
  bg = "NONE",
})

vim.api.nvim_set_hl(0, "CursorLineNr", {
  fg = "#aaaaaa",
})

-- For disableing speelcheck on md files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- for markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("i", ";", function()
      local line = vim.api.nvim_get_current_line()
      if line:match("^%s*$") then
        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row - 1, row, false, {
          "```",
          "",
          "```",
        })
        -- Move cursor to end of first ``` line
        vim.api.nvim_win_set_cursor(0, { row, 3 })
      else
        vim.api.nvim_feedkeys(";", "n", false)
      end
    end, { noremap = true, silent = true, buffer = true })
  end,
})
