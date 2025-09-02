return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "b0o/schemastore.nvim",
    {
      "saghen/blink.cmp",
      -- Ensure blink.cmp is loaded before lspconfig for capabilities
      lazy = false,
      priority = 100,
    },
  },
  config = function()
    -- Setup Mason first
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- Define the on_attach function with all keymaps
    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc)
        vim.keymap.set(
          "n",
          keys,
          func,
          { buffer = bufnr, noremap = true, silent = true, desc = "LSP: " .. desc }
        )
      end

      -- Navigation
      map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
      map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
      map("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")

      -- Documentation
      map("K", vim.lsp.buf.hover, "Hover Documentation")
      map("<leader>sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")

      -- Actions
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

      -- Diagnostics
      map("<leader>ld", vim.diagnostic.open_float, "Show [D]iagnostics")
      map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
      map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
      map("<leader>q", vim.diagnostic.setloclist, "Diagnostic [Q]uickfix")

      -- Workspace
      map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
      map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
      map("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "[W]orkspace [L]ist Folders")

      -- Toggle inlay hints if supported
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        map("<leader>th", function()
          local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
          vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
        end, "[T]oggle Inlay [H]ints")
      end

      -- Format on save if the client supports it
      if client.supports_method("textDocument/formatting") then
        local format_group = vim.api.nvim_create_augroup("LspFormat_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          group = format_group,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              timeout_ms = 2000,
              filter = function(formatter_client)
                -- Only use null-ls/none-ls for formatting if available
                if formatter_client.name == "null-ls" or formatter_client.name == "none-ls" then
                  return true
                end
                -- Otherwise use the LSP if no formatter is available
                local formatters = { "null-ls", "none-ls" }
                local clients = vim.lsp.get_clients({ bufnr = bufnr })
                for _, c in ipairs(clients) do
                  if vim.tbl_contains(formatters, c.name) then
                    return false -- Don't use this LSP for formatting
                  end
                end
                return true -- Use this LSP for formatting
              end,
            })
          end,
        })
      end
    end

    -- Get capabilities from blink.cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local blink_ok, blink = pcall(require, "blink.cmp")
    if blink_ok then
      -- Merge blink.cmp capabilities
      capabilities = blink.get_lsp_capabilities(capabilities)
    else
      vim.notify("Blink.cmp not found, using default LSP capabilities", vim.log.levels.WARN)
    end

    -- Define server configurations
    local servers = {
      -- TypeScript/JavaScript
      ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            format = {
              enable = false, -- Let prettier/eslint handle formatting
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            format = {
              enable = false,
            },
          },
        },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- Disable tsserver formatting in favor of prettier/eslint
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },

      -- Tailwind CSS
      tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "cva\\(([^)]*)\\)",  "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cn\\(([^)]*)\\)",   "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "clsx\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
              },
            },
            validate = true,
          },
        },
      },

      -- ESLint
      eslint = {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- Auto-fix on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              local ok, _ = pcall(vim.cmd, "silent! EslintFixAll")
              if not ok then
                -- Silently fail if EslintFixAll is not available
              end
            end,
          })
        end,
        settings = {
          workingDirectories = { mode = "auto" },
        },
      },

      -- JSON
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },

      -- YAML
      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
            validate = true,
            hover = true,
            completion = true,
          },
        },
      },

      -- Lua
      lua_ls = {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim", "require" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "tab",
                indent_size = "2",
              },
            },
            hint = {
              enable = true,
              arrayIndex = "Auto",
              await = true,
              paramName = "All",
              paramType = true,
              semicolon = "SameLine",
              setType = true,
            },
          },
        },
      },

      -- Python
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              typeCheckingMode = "standard",
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              autoImportCompletions = true,
            },
          },
        },
      },

      -- Alternative: Ruff for Python (faster linting)
      ruff = {
        init_options = {
          settings = {
            args = {}, -- Add any extra CLI arguments for ruff here
          },
        },
      },

      -- Go
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
      },

      -- Rust
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,
            },
            inlayHints = {
              chainingHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              lifetimeElisionHints = { enable = "always" },
              parameterHints = { enable = true },
              typeHints = { enable = true },
            },
          },
        },
      },

      -- C/C++
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          offsetEncoding = { "utf-16" },
        }),
      },

      -- Web development
      html = {
        settings = {
          html = {
            format = {
              enable = true,
            },
          },
        },
      },
      cssls = {
        settings = {
          css = {
            validate = true,
          },
          less = {
            validate = true,
          },
          scss = {
            validate = true,
          },
        },
      },
      emmet_ls = {
        filetypes = {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
        },
      },

      -- Docker
      dockerls = {},
      docker_compose_language_service = {},

      -- Bash
      bashls = {},

      -- Vim
      vimls = {},

      -- Prisma
      prismals = {},

      -- GraphQL
      graphql = {
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      },

      -- Svelte
      svelte = {
        settings = {
          svelte = {
            plugin = {
              svelte = {
                compilerWarnings = {
                  ["a11y-no-onchange"] = "ignore",
                },
              },
            },
          },
        },
      },

      -- Astro
      astro = {},
    }

    -- Setup mason-lspconfig with ensure_installed
    local mason_lspconfig = require("mason-lspconfig")

    -- Get list of servers to ensure installed
    local ensure_installed = vim.tbl_keys(servers)

    mason_lspconfig.setup({
      ensure_installed = ensure_installed,
      automatic_installation = true,
    })

    -- Get lspconfig
    local lspconfig = require("lspconfig")

    -- Setup each server
    for server_name, server_config in pairs(servers) do
      -- Only set on_attach if not already defined
      if not server_config.on_attach then
        server_config.on_attach = on_attach
      end
      -- Only set capabilities if not already defined
      if not server_config.capabilities then
        server_config.capabilities = capabilities
      end
      server_config.flags = {
        debounce_text_changes = 150,
      }

      -- Setup the server
      lspconfig[server_name].setup(server_config)
    end

    -- Configure diagnostics
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 4,
        source = "if_many",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
        },
      },
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        focusable = false,
      },
    })

    -- Show line diagnostics automatically in hover window
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
      callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
      end,
    })

    -- Set updatetime for CursorHold
    vim.o.updatetime = 250
  end,
}
