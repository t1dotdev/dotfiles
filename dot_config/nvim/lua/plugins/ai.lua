vim.keymap.set({ "n", "v" }, "<leader>aa", ":CodeCompanionAction<CR>", { desc = "[A]i [A]ction" })
vim.keymap.set("v", "<leader>ae", ":CodeCompanion<CR>", { desc = "[A]i [E]dit" })

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
      copilot_model = "gpt-4o-copilot",
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "LazyFile",
    config = function()
      require("codecompanion").setup({
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-sonnet-4",
                },
              },
            })
          end,
        },
      })
    end,
  },

  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      { "ga", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    opts = {
      terminal = {
        ---@module "snacks"
        ---@type snacks.win.Config|{}
        snacks_win_opts = {
          position = "right",
          width = 0.4,
          height = 0.9,
          keys = {
            claude_hide = {
              "<C-,>",
              function(self)
                self:hide()
              end,
              mode = "t",
              desc = "Hide",
            },
          },
        },
      },
    },
  },
  -- {
  --   "NickvanDyke/opencode.nvim",
  --   dependencies = { "folke/snacks.nvim" },
  --   ---@type opencode.Config
  --   opts = {
  --     -- Your configuration, if any
  --   },
  -- -- stylua: ignore
  -- keys = {
  --   { '<leader>ot', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
  --   { '<leader>oa', function() require('opencode').ask('@cursor: ') end, desc = 'Ask opencode', mode = 'n', },
  --   { '<leader>oa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
  --   { '<leader>op', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
  --   { '<leader>on', function() require('opencode').command('session_new') end, desc = 'New session', },
  --   { '<leader>oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
  --   { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
  --   { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
  -- },
  -- },
  -- {
  --   "greggh/claude-code.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- Required for git operations
  --   },
  --   keys = {
  --     { "<C-,>", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" } },
  --   },
  --   config = function()
  --     require("claude-code").setup({
  --       window = {
  --         split_ratio = 0.3, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
  --         position = "float", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
  --         enter_insert = true, -- Whether to enter insert mode when opening Claude Code
  --         hide_numbers = true, -- Hide line numbers in the terminal window
  --         hide_signcolumn = true, -- Hide the sign column in the terminal window
  --
  --         -- Floating window configuration (only applies when position = "float")
  --         float = {
  --           width = "80%", -- Width: number of columns or percentage string
  --           height = "80%", -- Height: number of rows or percentage string
  --           row = "center", -- Row position: number, "center", or percentage string
  --           col = "center", -- Column position: number, "center", or percentage string
  --           relative = "editor", -- Relative to: "editor" or "cursor"
  --           border = "rounded", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
  --         },
  --       },
  --       shell = {
  --         separator = ";", -- Command separator used in shell commands
  --         pushd_cmd = "cd", -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
  --         popd_cmd = "", -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
  --       },
  --     })
  --   end,
  -- },
}
