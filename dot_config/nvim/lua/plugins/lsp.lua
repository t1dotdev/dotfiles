return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "williamboman/mason.nvim",
      config = true,
    },
    "williamboman/mason-lspconfig.nvim",
    "b0o/schemastore.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local ok_lsp, lspconfig = pcall(require, "lspconfig")
    if not ok_lsp then
      vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
      return
    end

    local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not ok_mason then
      vim.notify("Failed to load mason-lspconfig", vim.log.levels.ERROR)
      return
    end

    -- Global LSP settings
    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Diagnostic signs
    local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Global on_attach function
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- Enable completion
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Global keymaps
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
      vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
        vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
      vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,
        vim.tbl_extend("force", opts, { desc = "Workspace Add Folder" }))
      vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
        vim.tbl_extend("force", opts, { desc = "Workspace Remove Folder" }))
      vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, vim.tbl_extend("force", opts, { desc = "Workspace List Folders" }))
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition,
        vim.tbl_extend("force", opts, { desc = "Type Definition" }))
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
        vim.tbl_extend("force", opts, { desc = "Code Action" }))
      vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, vim.tbl_extend("force", opts, { desc = "Format" }))

      -- Inlay hints toggle
      if client.supports_method("textDocument/inlayHint") then
        vim.keymap.set("n", "<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, vim.tbl_extend("force", opts, { desc = "Toggle Inlay Hints" }))
      end
    end

    -- Capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { "documentation", "detail", "additionalTextEdits" },
    }

    -- Server-specific configurations
    local server_configs = {
      -- TypeScript/JavaScript
      vtsls = {
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
        on_attach = function(client, bufnr)
          -- Call global on_attach
          on_attach(client, bufnr)

          local opts = { noremap = true, silent = true, buffer = bufnr }

          -- Setup custom command for move to file refactoring
          client.commands = client.commands or {}
          client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
            local action, uri, range = unpack(command.arguments)

            local function move(newf)
              client.request("workspace/executeCommand", {
                command = command.command,
                arguments = { action, uri, range, newf },
              })
            end

            local fname = vim.uri_to_fname(uri)
            client.request("workspace/executeCommand", {
              command = "typescript.tsserverRequest",
              arguments = {
                "getMoveToRefactoringFileSuggestions",
                {
                  file = fname,
                  startLine = range.start.line + 1,
                  startOffset = range.start.character + 1,
                  endLine = range["end"].line + 1,
                  endOffset = range["end"].character + 1,
                },
              },
            }, function(_, result)
              local files = result.body.files
              table.insert(files, 1, "Enter new path...")
              vim.ui.select(files, {
                prompt = "Select move destination:",
                format_item = function(f)
                  return vim.fn.fnamemodify(f, ":~:.")
                end,
              }, function(f)
                if f and f:find("^Enter new path") then
                  vim.ui.input({
                    prompt = "Enter move destination:",
                    default = vim.fn.fnamemodify(fname, ":h") .. "/",
                    completion = "file",
                  }, function(newf)
                    return newf and move(newf)
                  end)
                elseif f then
                  move(f)
                end
              end)
            end)
          end

          -- TypeScript-specific keybindings
          -- Go to source definition
          vim.keymap.set("n", "gD", function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf.execute_command({
              command = "typescript.goToSourceDefinition",
              arguments = { params.textDocument.uri, params.position },
            })
          end, vim.tbl_extend("force", opts, { desc = "Goto Source Definition" }))

          -- Find all file references
          vim.keymap.set("n", "gR", function()
            vim.lsp.buf.execute_command({
              command = "typescript.findAllFileReferences",
              arguments = { vim.uri_from_bufnr(0) },
            })
          end, vim.tbl_extend("force", opts, { desc = "File References" }))

          -- Organize imports
          vim.keymap.set("n", "<leader>co", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              },
            })
          end, vim.tbl_extend("force", opts, { desc = "Organize Imports" }))

          -- Add missing imports
          vim.keymap.set("n", "<leader>cM", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.addMissingImports.ts" },
                diagnostics = {},
              },
            })
          end, vim.tbl_extend("force", opts, { desc = "Add missing imports" }))

          -- Remove unused imports
          vim.keymap.set("n", "<leader>cu", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.removeUnused.ts" },
                diagnostics = {},
              },
            })
          end, vim.tbl_extend("force", opts, { desc = "Remove unused imports" }))

          -- Fix all diagnostics
          vim.keymap.set("n", "<leader>cD", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.fixAll.ts" },
                diagnostics = {},
              },
            })
          end, vim.tbl_extend("force", opts, { desc = "Fix all diagnostics" }))

          -- Select TypeScript version
          vim.keymap.set("n", "<leader>cV", function()
            vim.lsp.buf.execute_command({ command = "typescript.selectTypeScriptVersion" })
          end, vim.tbl_extend("force", opts, { desc = "Select TS workspace version" }))
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
            command = "EslintFixAll",
          })
        end,
      },

      -- CSS/SCSS/Less
      cssls = {
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      },

      -- HTML
      html = {
        filetypes = { "html", "templ" },
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

      -- Lua
      lua_ls = {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
            format = {
              enable = false,
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
            },
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
          },
        },
      },

      -- Bash
      bashls = {},
    }

    -- Setup mason-lspconfig with ensure_installed servers
    mason_lspconfig.setup({
      ensure_installed = {
        "vtsls",
        "eslint",
        "tailwindcss",
        "cssls",
        "html",
        "jsonls",
        "lua_ls",
        "pyright",
        "yamlls",
        "bashls",
      },
      -- Setup handlers for mason-lspconfig
      handlers = {
        -- Default handler
        function(server_name)
          local config = server_configs[server_name] or {}
          config.capabilities = capabilities
          if not config.on_attach then
            config.on_attach = on_attach
          end
          lspconfig[server_name].setup(config)
        end,

        -- Disable conflicting TypeScript servers
        ["tsserver"] = function() end,
        ["ts_ls"] = function() end,

        -- Custom handler for vtsls to ensure on_attach is preserved
        ["vtsls"] = function()
          local config = server_configs.vtsls or {}
          config.capabilities = capabilities
          lspconfig.vtsls.setup(config)
        end,
      },
    })

    -- Manually setup vtsls if not installed via Mason
    if vim.fn.executable("vtsls") == 1 then
      local vtsls_config = server_configs.vtsls or {}
      vtsls_config.capabilities = capabilities
      lspconfig.vtsls.setup(vtsls_config)
    end
  end,
}
