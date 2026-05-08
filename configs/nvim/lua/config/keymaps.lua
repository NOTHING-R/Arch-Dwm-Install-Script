-- Map Ctrl+Backspace to delete previous word in insert mode (like Ctrl-w)
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete previous word" })

-- Fallback for terminals that send Ctrl+H for Ctrl+Backspace
vim.keymap.set("i", "<C-H>", "<C-w>", { desc = "Delete previous word (fallback)" })

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ==========================
-- JJ FOR ESC
-- ==========================
-- vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
map("i", "jj", "<Esc>", opts)
map("n", "<leader>nn", "zt", opts)

-- Disable LazyVim's default <leader>bb
vim.keymap.del("n", "<leader>bb")
-- Rebind to <leader>h
-- map("n", "<leader>h", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Remap Lazy UI from <leader>l to <leader>ll
vim.keymap.del("n", "<leader>l")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- toggel fold for codes
vim.keymap.set("n", "<Tab>", "za", { desc = "Toggle fold" })
map("n", "<leader>J", ":Ex ", opts)
-- ==========================
-- Window Management (SPC-w)
-- ==========================
map("n", "<leader>ww", "<C-w>w", { desc = "Switch to next window" })
map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
map("n", "<leader>ws", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close window" })

-- ==========================
-- Buffer Management (SPC-b)
-- ==========================
map("n", "<leader>j", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>k", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>hh", "<cmd>bdelete<CR>", { desc = "Kill/Close buffer" })

-- Help / Info (SPC-h)
-- ==========================
map("n", "<leader>hk", "<cmd>help<CR>", { desc = "Vim help" })
map("n", "<leader>hm", "<cmd>:messages<CR>", { desc = "Show messages" })

-- extra added
vim.keymap.set("n", "<leader>fs", function()
  require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Swiper-like search (buffer)" })

-- for jj exit on terminal
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.keymap.set("t", "jj", [[<C-\><C-n>]], { noremap = true, silent = true })

-- ==========================
-- PERSONAL FOLDER SHORTCUTS (SPC-f-p)
-- ==========================
vim.keymap.set("n", "<leader>faa", function()
  require("telescope.builtin").find_files({ cwd = "~/my-shared-fiels/Progrmain Notes/" })
end, { desc = "Find in Notes" })

-- FUZZY FIND
local builtin = require("telescope.builtin")
local fb = require("telescope").extensions.file_browser
local wk = require("which-key")

wk.add({
  {
    "<leader>.",
    function()
      fb.file_browser({
        path = vim.fn.expand("%:p:h"), -- current file dir (IMPORTANT)
        select_buffer = true,
      })
    end,
    desc = "File Browser (current dir)",
  },
})

vim.keymap.set("n", "<leader><space>", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or vim.fn.getcwd(),
  })
end, { desc = "Find Files from git root" })

-- Generate/update a Markdown TOC
-- To generate the TOC I use the markdown-toc plugin
-- https://github.com/jonschlinkert/markdown-toc
-- And the markdown-toc plugin installed as a LazyExtra
-- Function to update the Markdown TOC with customizable headings

local function update_markdown_toc(heading2, heading3)
  local path = vim.fn.expand("%") -- Expands the current file name to a full path
  local bufnr = 0 -- The current buffer number, 0 references the current active buffer
  -- Save the current view
  -- If I don't do this, my folds are lost when I run this keymap
  vim.cmd("mkview")
  -- Retrieves all lines from the current buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local toc_exists = false -- Flag to check if TOC marker exists
  local frontmatter_end = 0 -- To store the end line number of frontmatter
  -- Check for frontmatter and TOC marker
  for i, line in ipairs(lines) do
    if i == 1 and line:match("^---$") then
      -- Frontmatter start detected, now find the end
      for j = i + 1, #lines do
        if lines[j]:match("^---$") then
          frontmatter_end = j
          break
        end
      end
    end
    -- Checks for the TOC marker
    if line:match("^%s*<!%-%-%s*toc%s*%-%->%s*$") then
      toc_exists = true
      break
    end
  end
  -- Inserts H2 and H3 headings and <!-- toc --> at the appropriate position
  if not toc_exists then
    local insertion_line = 1 -- Default insertion point after first line
    if frontmatter_end > 0 then
      -- Find H1 after frontmatter
      for i = frontmatter_end + 1, #lines do
        if lines[i]:match("^#%s+") then
          insertion_line = i + 1
          break
        end
      end
    else
      -- Find H1 from the beginning
      for i, line in ipairs(lines) do
        if line:match("^#%s+") then
          insertion_line = i + 1
          break
        end
      end
    end
    -- Insert the specified headings and <!-- toc --> without blank lines
    -- Insert the TOC inside a H2 and H3 heading right below the main H1 at the top lamw25wmal
    vim.api.nvim_buf_set_lines(bufnr, insertion_line, insertion_line, false, { heading2, heading3, "<!-- toc -->" })
  end
  -- Silently save the file, in case TOC is being created for the first time
  vim.cmd("silent write")
  -- Silently run markdown-toc to update the TOC without displaying command output
  -- vim.fn.system("markdown-toc -i " .. path)
  -- I want my bulletpoints to be created only as "-" so passing that option as
  -- an argument according to the docs
  -- https://github.com/jonschlinkert/markdown-toc?tab=readme-ov-file#optionsbullets
  vim.fn.system('markdown-toc --bullets "-" -i ' .. path)
  vim.cmd("edit!") -- Reloads the file to reflect the changes made by markdown-toc
  vim.cmd("silent write") -- Silently save the file
  vim.notify("TOC updated and file saved", vim.log.levels.INFO)
  -- -- In case a cleanup is needed, leaving this old code here as a reference
  -- -- I used this code before I implemented the frontmatter check
  -- -- Moves the cursor to the top of the file
  -- vim.api.nvim_win_set_cursor(bufnr, { 1, 0 })
  -- -- Deletes leading blank lines from the top of the file
  -- while true do
  --   -- Retrieves the first line of the buffer
  --   local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
  --   -- Checks if the line is empty
  --   if line == "" then
  --     -- Deletes the line if it's empty
  --     vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, {})
  --   else
  --     -- Breaks the loop if the line is not empty, indicating content or TOC marker
  --     break
  --   end
  -- end
  -- Restore the saved view (including folds)
  vim.cmd("loadview")
end

-- HACK: Create table of contents in neovim with markdown-toc
-- https://youtu.be/BVyrXsZ_ViA
--
-- Keymap for English TOC
vim.keymap.set("n", "<leader>mtt", function()
  update_markdown_toc("## Contents", "### Table of contents")
end, { desc = "[P]Insert/update Markdown TOC (English)" })

-- HACK: Create table of contents in neovim with markdown-toc
-- https://youtu.be/BVyrXsZ_ViA

vim.keymap.set("n", "<leader>fhf", function()
  vim.cmd("cd ~/.config/hypr")
  vim.cmd("Ex")
end, { desc = "Open Hypr config" })

-- ==========================
-- OPEN VIDEO UNDER CURSOR WITH MPV
-- ==========================
vim.keymap.set("n", "<leader>ov", function()
  local file = vim.fn.expand("<cfile>")
  vim.fn.jobstart({ "mpv", file }, { detach = true })
end, { desc = "Open video in mpv" })
