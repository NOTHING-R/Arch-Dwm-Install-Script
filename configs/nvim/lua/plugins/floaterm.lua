return {
  "voldikss/vim-floaterm",
  cmd = { "FloatermNew", "FloatermToggle" },
  keys = {
    {
      "<C-/>",
      "<cmd>FloatermToggle splitterm<CR>",
      desc = "Toggle split terminal",
      mode = { "n", "t" },
    },
    {
      "<leader>i",
      "<cmd>FloatermToggle floatterm<CR>",
      desc = "Toggle floating terminal",
      mode = { "n", "t" },
    },
  },
  init = function()
    vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
    vim.g.floaterm_title = " Terminal ($1/$2) "

    -- Split terminal
    vim.keymap.set("n", "<C-/>", function()
      vim.cmd("FloatermNew --name=splitterm --wintype=split --position=bottom --height=0.7")
    end, { silent = true, desc = "Toggle split terminal" })

    -- Floating terminal
    vim.keymap.set("n", "<leader>i", function()
      vim.cmd("FloatermNew --name=floatterm --width=0.99 --height=0.99 --wintype=float --position=center")
    end, { silent = true, desc = "Toggle floating terminal" })
  end,
}
