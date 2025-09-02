return {
  -- Faster startup
  {
    "lewis6991/impatient.nvim",
    enabled = false, -- Built into Neovim 0.9+
  },
  
  -- Better filetype detection
  {
    "nathom/filetype.nvim",
    enabled = false, -- Built into Neovim 0.8+
  },

  -- Optimize loading of large files
  {
    "pteroctopus/faster.nvim",
    event = "VeryLazy",
    config = function()
      require("faster").setup()
    end,
  },

  -- Improve startup time by caching
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
}