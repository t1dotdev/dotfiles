return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "flake8",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "rust_analyzer",
        -- "gopls", -- Requires Go to be installed
        "clangd",
        "html",
        "cssls",
        "jsonls",
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      
      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      if pcall(require, "blink.cmp") then
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      end
      
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              telemetry = { enable = false },
              diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
              },
            },
          },
        },
        ts_ls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
            },
          },
        },
        gopls = {},
        clangd = {},
        html = { filetypes = { "html", "twig", "hbs" } },
        cssls = {},
        jsonls = {},
      }
      
      -- Setup each server automatically
      for server_name, server_config in pairs(servers) do
        server_config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
        lspconfig[server_name].setup(server_config)
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "prettier",
        "prettierd",
        "stylua",
        "isort",
        "black",
        "pylint",
        "eslint_d",
        "shellcheck",
        "shfmt",
        -- "gofumpt", -- Requires Go
        -- "goimports", -- Requires Go
        -- "gomodifytags", -- Requires Go
        -- "impl", -- Requires Go
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
    },
  },
}
