-- Disable auto-continuing comments on Enter / o / O
-- This stops * , # , #+ etc. from repeating on new lines
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- Optional: Also apply it when filetype is detected (extra safety)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local groups = {
      "Normal",
      "NormalNC",
      "NormalFloat",
      "FloatBorder",
      "SignColumn",
      "LineNr",
      "CursorLine",
      "EndOfBuffer",
      "TelescopeNormal",
      "TelescopeBorder",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
    }
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
    -- Folded gets its own fg too
    vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", fg = "#545c7e" })
  end,
})
