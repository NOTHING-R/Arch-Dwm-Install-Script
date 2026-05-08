vim.opt.termguicolors = true
vim.cmd("highlight Normal guibg=none")
vim.cmd("highlight NormalFloat guibg=none")
vim.g.root_spec = { "cwd" }

vim.g.inlay_hints_enabled = true

-- For line warp
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"
vim.opt.showbreak = ""
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nv"

-- statusline + tabline are managed by lua/config/toggles.lua (hidden by default)

-- Extra added for directory
vim.opt.autochdir = false -- এটা off রাখাই better

vim.api.nvim_create_autocmd("FileType", {
  pattern = "org",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    -- vim.opt_local.breakindentopt = "shift:2"
    -- Make wrapped lines look clean
    vim.opt_local.showbreak = " "
    -- 👉 THIS fixes heading paragraph issue
    vim.opt_local.indentexpr = " "
  end,
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- don't fold everything on open
vim.opt.foldlevel = 99 -- start with all folds open

vim.opt.foldtext = ""
vim.opt.fillchars = { fold = " " }

vim.opt.laststatus = 0
vim.opt.showtabline = 0

vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.showmode = false
