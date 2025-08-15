return {
  {
    "sainnhe/sonokai",
    priority = 1000,
    config = function()
      vim.g.sonokai_transparent_background = 1
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_style = "andromeda"
      vim.cmd.colorscheme("sonokai")
    end,
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = true, -- Enable this to disable setting the background color
  --   },
  -- },
  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = true, -- Enable this to disable setting the background color
  --     variant = "dark",
  --   },
  -- },
  -- {
  --   "olimorris/onedarkpro.nvim",
  --   priority = 1000, -- Ensure it loads first
  --   opts = {
  --     transparency = true,
  --   },
  -- },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   opts = {
  --     transparent_background = true, -- disables setting the background color.
  --     flavour = "mocha", -- latte, frappe, macchiato, mocha
  --   },
  -- },
  -- {
  --   "eldritch-theme/eldritch.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = true, -- Enable this to disable setting the background color
  --   },
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "sonokai",
    },
  },
}
