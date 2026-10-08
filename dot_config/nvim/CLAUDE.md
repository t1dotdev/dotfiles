# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Neovim Configuration Overview

Modern Neovim configuration (requires **nvim 0.11+**, developed on 0.12) using the
NvChad UI framework with the lazy.nvim package manager. Built entirely in Lua with
a modular architecture. LSP is configured with **Neovim's native `vim.lsp`** API
(`lsp/*.lua` + `vim.lsp.enable`) — not nvim-lspconfig and not mason-lspconfig.

## Architecture

### Initialization Flow

1. `init.lua` requires config modules in order:
   `options` → `diagnostics` → `commands` → `autocmds` → `autocmds.entrypoint`
   → `autocmds.lsp-attach` → `lazy` → `keymaps`.
2. After lazy, `init.lua` loads the NvChad base46 highlight cache from
   `stdpath("data")/base46_cache/` (regenerating it if missing).

### Core Configuration Modules (`lua/config/`)

- `options.lua` - Vim options, leader-adjacent globals, provider disables, folding,
  Mason `bin` on PATH.
- `diagnostics.lua` - **Single source of truth** for `vim.diagnostic.config`
  (signs, float, `virtual_text = false` so tiny-inline-diagnostic renders inline).
- `commands.lua` - Custom user command `LspEnable` (enables every `lsp/*.lua`
  server and merges blink.cmp capabilities). Restart via builtin `:lsp restart`.
- `autocmds.lua` - General autocmds (yank highlight, last-loc, close-with-`q`,
  etc). Large files are handled by `snacks.bigfile`.
- `autocmds/entrypoint.lua` - `VimEnter` → runs `:LspEnable`.
- `autocmds/lsp-attach.lua` - `LspAttach`: buffer-local LSP keymaps, `:LspLog`.
  Reference highlight/jump is `snacks.words`; `[x`/`]x` live in `diagnostics.lua`;
  diagnostic undercurl is applied in `init.lua` after the base46 cache loads.
- `keymaps.lua` - Global, plugin-independent keybindings.
- `lua/chadrc.lua` - NvChad config: **catppuccin** theme, transparency, custom
  purple (`#7A6FF0`) float/border highlights.

### Plugin System (`lua/plugins/`)

One file per plugin, each returning a lazy.nvim spec:

- **UI/Navigation**: `snacks.lua` (picker, dashboard, statuscolumn, notifier, zen,
  toggles), `noice.lua`, `which-key.lua`, `tiny-inline-diagnostic.lua`.
- **Completion**: `blink-cmp.lua` (engine: LSP + snippets + path + buffer, custom
  context sort), `copilot.lua` (zbirenbaum, ghost text — accepted via blink's
  `<Tab>`). Snippets: friendly-snippets via blink's default `vim.snippet` preset.
- **LSP**: native — server specs live in top-level **`lsp/*.lua`**, enabled by
  `config/commands.lua`. `mason.lua` installs servers/formatters/linters via a
  custom auto-install + auto-clean sync (no mason-lspconfig).
- **Editing**: `conform.lua` (format), `treesitter.lua` (+textobjects, `master`
  branch), `ts-autotag.lua`, `flash.lua`, `mini-pairs.lua` (pairing),
  `ts-comments.lua`, `refactoring.lua`.
- **Files**: `fff.lua` (fast finder, `<leader><leader>`), `nvim-tree.lua`
  (`<leader>e`), `oil.lua` (`-`). `mini-icons.lua` provides icons (mocks
  nvim-web-devicons).
- **Git**: `gitsigns.lua` (signs in snacks statuscolumn, `]h`/`[h`, `<leader>gh…`).
- **Tools**: `grug-far.lua` (find/replace), `trouble.lua` (diagnostics list, v3),
  `todo-comments.lua`, `persistence.lua` (sessions), `claudecode.lua` (AI,
  `<leader>a…`), `tmux.lua` (vim-herdr-navigation, falls back to
  vim-tmux-navigator).

## Development Commands

```vim
:checkhealth          " Health of all plugins
:checkhealth vim.lsp  " Native LSP client status (replaces :LspInfo)
:ConformInfo          " Formatter status for current buffer
:Lazy / :Lazy sync    " Plugin manager UI / sync with lazy-lock.json
:Mason                " Install/manage LSP servers, formatters, linters
:LspEnable            " (custom) enable all lsp/*.lua servers
:lsp restart          " (builtin) restart LSP clients on current buffer
:LspLog               " (custom) open the LSP log file
```

## LSP

Native `vim.lsp`. Each enabled server is a file in **`lsp/<name>.lua`** returning a
`vim.lsp.Config` table (`cmd`, `filetypes`, `root_markers`/`root_dir`, `settings`).
`config/commands.lua` discovers every `lsp/*.lua`, merges blink.cmp completion
capabilities into `vim.lsp.config("*")`, then calls `vim.lsp.enable`.

Currently enabled servers: `ts_ls`, `eslint`, `html`, `jsonls`, `tailwind`,
`cssls`, `css_variables`, `cssmodules_ls`, `emmet_language_server`, `svelte`,
`yamlls`, `docker_language_server` (Dockerfile only; compose is plain `yaml`),
`marksman`, `gopls`, `rust_analyzer`, `luals` (lua, with VIMRUNTIME types),
`pyright` (python), `harperls` (markdown grammar), `nushell`.

To enable another server: install it via `mason.lua`'s `PACKAGES`, then add an
`lsp/<name>.lua` config. Every Mason server in `PACKAGES` has a config.

## Formatting (Conform)

Format on save (`format_on_save`, 500ms, LSP fallback); manual `<leader>cf`.

- JS/TS/JSX/TSX/Svelte/CSS/HTML/JSON/YAML/Markdown/GraphQL: **prettierd**
- Lua: stylua · Python: isort + black · Go: goimports + gofmt
- Rust: rustfmt · Shell: shfmt (`-i 2`)

Formatter binaries are installed by `mason.lua` (prettierd, isort, black, stylua,
shfmt, goimports); gofmt/rustfmt come from the Go/Rust toolchains on `PATH`.

## Key Bindings Reference

### Navigation

- `<Space>` - Leader
- `<leader><leader>` - Fast file finder (fff.nvim)
- `<leader>e` - File explorer (nvim-tree); `-` - Oil (parent dir)
- `<leader>/` or `<leader>sg` - Live grep · `<leader>,` - Buffers
- `<C-h/j/k/l>` - Seamless vim/herdr/tmux pane navigation (also escapes terminal
  windows)

### LSP (buffer-local, on attach)

- `gd`/`gr`/`gI`/`gy` - Definition/References/Implementation/Type def (Snacks picker)
- `K` - Hover · `<leader>rn` - Rename · `<leader>ca` - Code action
- `<leader>cu`/`<leader>co`/`<leader>ci` - ts_ls remove-unused / organize / add-missing imports
- `[x`/`]x` - Prev/next error · `[[`/`]]` - Prev/next reference (snacks.words)
- `<leader>uh` - Toggle inlay hints (Snacks toggle)

### Editing / Tools

- `<C-s>` - Save (all modes) · `<leader>cf` - Format buffer · `<leader>qq` - Quit all
- `]k`/`[k` - Next/prev class (treesitter; `]c`/`[c` left for diff hunks)
- `<leader>cx`/`<leader>cX` - Swap parameter next/prev
- `<leader>sr` - Find/replace (grug-far) · `<leader>xx` - Diagnostics (Trouble)
- `<leader>ff`/`<leader>fr`/`<leader>fg` - Find files / recent / git files
- `]h`/`[h` - Next/prev git hunk · `<leader>gh{s,r,p,b,R}` - Stage/reset/preview/blame/reset buffer
- `<leader>a…` - Claude Code (toggle, focus, resume, send, diff accept/deny)

## Important Implementation Details

- **Theme**: NvChad base46 (catppuccin, transparency). Regenerate cache by deleting
  `~/.local/share/nvim/base46_cache/` and restarting.
- **Diagnostics**: tiny-inline-diagnostic renders inline; the one `vim.diagnostic.config`
  lives in `lua/config/diagnostics.lua` (do not re-configure elsewhere).
- **Completion**: blink.cmp (not nvim-cmp). Copilot is zbirenbaum/copilot.lua (ghost
  text); its suggestion is accepted by blink's `<Tab>` (the blink-cmp-copilot source
  is intentionally not used).
- **Pairing**: mini.pairs (not nvim-autopairs). **Icons**: mini.icons (mocks
  nvim-web-devicons; do not add the real plugin as a dependency).
- **Notifications**: snacks.notifier owns `vim.notify`; noice has `notify.enabled = false`.
- **Pickers**: Snacks picker + fff.nvim (not telescope). **Statuscolumn**: snacks.
- **Multiplexer**: herdr/tmux (vim-herdr-navigation + vim-tmux-navigator).
- **Window borders**: custom purple (`#7A6FF0`) for floats.

## Adding New Plugins

1. Create `lua/plugins/<name>.lua` returning a lazy.nvim spec.
2. `:Lazy sync` to install. 3. Add global keymaps in `lua/config/keymaps.lua`, or
   prefer the spec's own `keys =` for lazy-loading. Avoid defining a key in both
   `keymaps.lua` and a plugin spec — `keymaps.lua` loads last and wins.

## Troubleshooting

- **Broken highlights**: delete `~/.local/share/nvim/base46_cache/` and restart.
- **LSP not working**: `:checkhealth vim.lsp`, `:LspLog`, `:Mason`.
- **Slow startup**: `:Lazy profile`.
- **Missing icons**: install a Nerd Font and configure the terminal.
