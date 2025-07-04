return {
  -- messages, cmdline and the popupmenu

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        -- show_buffer_close_icons = false,
        -- show_close_icon = false,
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    -- enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")
      local lazy_status = require("lazy.status")
      local LazyVim = require("lazyvim.util")

      -- Soft modern color palette
      local colors = {
        primary = "#875fff", -- soft violet
        blue = "#2563eb", -- soft blue
        green = "#34d399", -- teal-green
        violet = "#f472b6", -- pink-violet
        yellow = "#f59e0b", -- warm yellow
        red = "#f87171", -- soft red
        fg = "#cbd5e1", -- slate-200
        bg = nil, -- transparent
        inactive_bg = nil,
      }

      local my_lualine_theme = {
        normal = {
          a = { bg = colors.primary, fg = colors.bg, gui = "bold" },
          c = { fg = colors.fg, bg = colors.bg },
        },
        insert = {
          a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
          c = { fg = colors.fg, bg = colors.bg },
        },
        visual = {
          a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
          c = { fg = colors.fg, bg = colors.bg },
        },
        command = {
          a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
          c = { fg = colors.fg, bg = colors.bg },
        },
        replace = {
          a = { bg = colors.red, fg = colors.bg, gui = "bold" },
          c = { fg = colors.fg, bg = colors.bg },
        },
        inactive = {
          a = { fg = "#94a3b8", bg = colors.bg, gui = "bold" },
          c = { fg = colors.fg, bg = colors.bg },
        },
      }

      lualine.setup({
        options = {
          theme = my_lualine_theme,
          section_separators = "",
          component_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_c = {
            LazyVim.lualine.pretty_path({
              length = 0,
              relative = "cwd",
              modified_hl = "MatchParen",
              directory_hl = "",
              filename_hl = "Bold",
              modified_sign = "",
              readonly_icon = " 󰌾 ",
              color = { fg = colors.fg },
            }),
          },
          lualine_x = {
            {
              lazy_status.updates,
              cond = lazy_status.has_updates,
              color = { fg = "#ff9e64" },
            },
            { "filetype" },
          },
        },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    event = "VeryLazy",
    ---@type snacks.Config
    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
      {
        "<leader><leader>",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            auto_close = true,
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },

  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
████████╗ ██╗██████╗  ██████╗ ████████╗██████╗ ███████╗██╗   ██╗
╚══██╔══╝███║██╔══██╗██╔═══██╗╚══██╔══╝██╔══██╗██╔════╝██║   ██║
   ██║   ╚██║██║  ██║██║   ██║   ██║   ██║  ██║█████╗  ██║   ██║
   ██║    ██║██║  ██║██║   ██║   ██║   ██║  ██║██╔══╝  ╚██╗ ██╔╝
   ██║    ██║██████╔╝╚██████╔╝   ██║   ██████╔╝███████╗ ╚████╔╝ 
   ╚═╝    ╚═╝╚═════╝  ╚═════╝    ╚═╝   ╚═════╝ ╚══════╝  ╚═══╝  
 ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "g", desc = "Lazygit", action = ":lua require('lazygit').lazygit()", enabled = vim.fn.isdirectory(".git") == 1},
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Function to set highlight groups
      local function set_snacks_highlights()
        vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#905aff", bold = true })
        vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#ffffff", bold = true })
        vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#905aff", italic = true })
        vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#ffffff", bold = true }) -- Pink for icons
        vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#ffffff", italic = true })
        vim.api.nvim_set_hl(0, "SnacksDashboardProjects", { fg = "#905aff", bold = true })
        vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = "#ffffff", bold = true }) -- Gold color for titles
        vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#905aff" }) -- Spring green for icons
        vim.api.nvim_set_hl(0, "SnacksDashboardFile", { fg = "#ffffff", bold = true }) -- Gold color for files
        vim.api.nvim_set_hl(0, "SnacksDashboardDir", { fg = "#905aff" }) -- Hot pink for directories
      end

      -- Apply highlights immediately
      set_snacks_highlights()

      -- Reapply highlights after colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_snacks_highlights,
      })
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    keys = {
      {
        "<leader>gg",
        ":LazyGit<Return>",
        silent = true,
        noremap = true,
      },
    },

    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {
      highlighters = {
        hsl_color = {
          pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
          group = function(_, match)
            local utils = require("solarized-osaka.hsl")
            --- @type string, string, string
            local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
            --- @type number?, number?, number?
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
            --- @type string
            local hex_color = utils.hslToHex(h, s, l)
            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
      },
    },
  },
}
