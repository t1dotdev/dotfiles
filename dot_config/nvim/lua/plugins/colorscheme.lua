return {
  -- {
  --   "sainnhe/sonokai",
  --   priority = 1000,
  --   config = function()
  --     vim.g.sonokai_transparent_background = 1
  --     vim.g.sonokai_enable_italic = 1
  --     vim.g.sonokai_style = "andromeda"
  --     vim.cmd.colorscheme("sonokai")
  --   end,
  -- },
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true, -- Enable this to disable setting the background color
    },
  },
  -- {
  -- 	"LazyVim/LazyVim",
  -- 	opts = {
  -- 		colorscheme = "sonokai",
  -- 	},
  -- },
}
