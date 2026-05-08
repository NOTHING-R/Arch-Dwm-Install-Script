return {
  {
    "3rd/image.nvim",
    lazy = false,
    priority = 999,
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = true, -- only show image when cursor is on that line/section
          filetypes = { "markdown" },
        },
      },
      max_width_window_percentage = 60,
      max_height_window_percentage = 40,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true,
    },
    config = function(_, opts)
      require("image").setup(opts)

      -- Toggle all inline images on/off
      vim.keymap.set("n", "<leader>oi", function()
        local api = require("image")
        if vim.g.images_hidden then
          api.enable()
          vim.g.images_hidden = false
          vim.notify("Images shown", vim.log.levels.INFO)
        else
          api.disable()
          vim.g.images_hidden = true
          vim.notify("Images hidden", vim.log.levels.INFO)
        end
      end, { desc = "Toggle inline images" })
    end,
  },
}

-- return {
--   {
--     "3rd/image.nvim",
--     lazy = false,
--     priority = 999,
--     opts = {
--       backend = "kitty",
--       processor = "magick_cli",
--       integrations = {
--         markdown = {
--           enabled = true,
--           clear_in_insert_mode = true,
--           download_remote_images = true,
--           only_render_image_at_cursor = true, -- default: cursor-only
--           filetypes = { "markdown" },
--         },
--       },
--       max_width_window_percentage = 60,
--       max_height_window_percentage = 40,
--       window_overlap_clear_enabled = true,
--       editor_only_render_when_focused = true,
--     },
--     config = function(_, opts)
--       require("image").setup(opts)
--
--       -- Toggle show ALL images in file at once (no hovering)
--       vim.keymap.set("n", "<leader>oi", function()
--         local state = require("image.utils.state")
--         local integration = state.options.integrations.markdown
--         if integration.only_render_image_at_cursor == false then
--           -- switch back to cursor-only
--           integration.only_render_image_at_cursor = true
--           require("image").clear()
--           vim.notify("Images: cursor-only mode", vim.log.levels.INFO)
--         else
--           -- show all images
--           integration.only_render_image_at_cursor = false
--           require("image").clear()
--           -- re-render by triggering a fake cursor move
--           vim.cmd("doautocmd CursorMoved")
--           vim.notify("Images: show all mode", vim.log.levels.INFO)
--         end
--       end, { desc = "Toggle show all images / cursor-only" })
--
--       -- Toggle images completely on/off
--       vim.keymap.set("n", "<leader>oI", function()
--         local api = require("image")
--         if vim.g.images_hidden then
--           api.enable()
--           vim.g.images_hidden = false
--           vim.notify("Images enabled", vim.log.levels.INFO)
--         else
--           api.disable()
--           vim.g.images_hidden = true
--           vim.notify("Images disabled", vim.log.levels.INFO)
--         end
--       end, { desc = "Toggle inline images on/off" })
--     end,
--   },
-- }
