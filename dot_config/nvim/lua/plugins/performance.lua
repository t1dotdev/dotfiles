return {
  -- Optimize loading of large files
  {
    "pteroctopus/faster.nvim",
    event = "VeryLazy",
    config = function()
      require("faster").setup()
    end,
  },
}
