# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Neovim Configuration Overview

Modern Neovim configuration using NvChad UI framework with lazy.nvim package
manager. Built entirely in Lua with modular plugin architecture.

## Architecture

### Initialization Flow

1. `init.lua` loads configuration modules in order: options → lazy → keymaps
2. Base46 cache is loaded for NvChad theming (stored in
   `~/.local/share/nvim/base46_cache/`)
3. Custom highlight groups are applied for transparency and UI elements

### Core Configuration Modules

- `lua/config/options.lua` - Vim options and settings
- `lua/config/lazy.lua` - Plugin manager bootstrap and spec loader
- `lua/config/keymaps.lua` - Global keybindings
- `lua/chadrc.lua` - NvChad theme configuration (eldritch theme with
  transparency)

### Plugin System

Each plugin has its own file in `lua/plugins/`:

- **UI/Navigation**: `snacks.lua` (picker, explorer, dashboard), `noice.lua`,
  `which-key.lua`
- **Completion**: `blink.lua` (main completion engine with LSP, snippets,
  copilot sources)
- **LSP**: `lsp.lua` (TypeScript, ESLint, Tailwind, HTML, CSS, JSON),
  `mason.lua` (LSP installer)
- **Editing**: `conform.lua` (formatting), `treesitter.lua` (syntax),
  `ts-autotag.lua`, `flash.lua` (motion)
- **Tools**: `copilot.lua`, `grug-far.lua` (find/replace), `persistence.lua`
  (sessions)

## Development Commands

### Testing & Validation

```vim
:checkhealth          " Check all plugins health
:LspInfo             " Check LSP server status
:ConformInfo         " Check formatter status
:Lazy health         " Check lazy.nvim health
```

### Plugin Management

```vim
:Lazy                " Open plugin manager UI
:Lazy update         " Update all plugins
:Lazy sync           " Sync plugin state with lockfile
:Lazy restore        " Restore plugins from lockfile
```

### LSP Commands

```vim
:Mason               " Open Mason UI for LSP management
:MasonUpdate         " Update Mason registry
:LspInstall [server] " Install specific LSP server
:LspRestart          " Restart LSP servers
```

## Key Bindings Reference

### Essential Navigation

- `<Space>` - Leader key
- `<leader><space>` - Smart file finder (respects .gitignore)
- `<leader>e` - File explorer (Snacks)
- `<leader>/` - Live grep in project
- `<leader>,` - Switch buffers
- `<C-h/j/k/l>` - Navigate windows (works in terminal too)

### LSP Operations (active in code files)

- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>th` - Toggle inlay hints

### File Operations

- `<C-s>` - Save file (all modes)
- `<leader>ff` - Find files
- `<leader>fr` - Recent files
- `<leader>fg` - Git files

## Plugin-Specific Configuration

### Blink Completion

- Sources: LSP → Copilot → Snippets → Path → Buffer (priority order)
- `<Tab>` - Accept/next suggestion
- `<C-space>` - Trigger completion manually
- Ghost text enabled for inline suggestions

### LSP Setup

Configured servers with Mason auto-install:

- `ts_ls` - TypeScript/JavaScript with inlay hints
- `eslint` - Auto-fix on save enabled
- `tailwindcss` - Extended class detection for cn() and cva()
- `jsonls` - With schemastore.nvim integration

### Formatting (Conform)

Auto-format on save for:

- JavaScript/TypeScript: Prettier
- Python: Black, isort
- Lua: Stylua
- Go: gofmt, goimports

## Important Implementation Details

- **Theme System**: Uses NvChad's base46 caching - regenerate with
  `:NvChadUpdate` after theme changes
- **Statuscolumn**: Managed by snacks.nvim, not statuscol.nvim
- **File Picker**: Snacks picker is primary, not telescope
- **Completion**: Blink.cmp handles all completion, not nvim-cmp
- **Copilot Integration**: Through blink-cmp-copilot, not copilot.vim
- **Window Borders**: Custom purple borders (#875fff) for floating windows

## Adding New Plugins

1. Create new file in `lua/plugins/plugin-name.lua`
2. Return plugin spec table with lazy.nvim format
3. Run `:Lazy sync` to install
4. Add keymaps to `lua/config/keymaps.lua` if needed

## Troubleshooting

- **Broken highlights**: Delete `~/.local/share/nvim/base46_cache/` and restart
- **LSP not working**: Run `:LspInfo` and `:Mason` to check installation
- **Slow startup**: Run `:Lazy profile` to identify slow plugins
- **Missing icons**: Ensure Nerd Font is installed and terminal configured

