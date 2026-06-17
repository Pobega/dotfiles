# Neovim config

A hand-rolled [lazy.nvim](https://github.com/folke/lazy.nvim) configuration —
the Neovim counterpart to the plugin-as-submodule `vim/.vim` setup, but using a
plugin manager because Neovim's LSP/Treesitter/completion stack needs the glue.

## Layout

```
init.lua                 -- leader + requires
lua/config/
  options.lua            -- vim.opt settings (ported from the old vimrc)
  keymaps.lua            -- global, non-plugin keymaps
  autocmds.lua           -- autocommands (ported from the old vimrc)
  lazy.lua               -- bootstraps lazy.nvim, imports lua/plugins/
lua/plugins/
  colorscheme.lua        -- gruvbox (default) + tokyonight/catppuccin/kanagawa
  treesitter.lua         -- syntax/indent/fold for lua, rust, python, starlark, ...
  lsp.lua                -- mason + nvim-lspconfig (rust_analyzer, pyright, ruff, lua_ls)
  completion.lua         -- nvim-cmp (replaces supertab)
  formatting.lua         -- conform.nvim (rustfmt, ruff, buildifier, stylua)
  lint.lua               -- nvim-lint (selene, shellcheck)
  git.lua                -- gitsigns, vim-fugitive, jjsigns
  git-tui.lua            -- floating lazygit / jj TUIs (toggleterm)
  editor.lua             -- telescope, which-key, smart-splits, toggleterm, vim-sleuth
  explorer.lua           -- neo-tree file explorer
  autopairs.lua          -- nvim-autopairs (cmp-aware)
  indent.lua             -- indent-blankline guides
  navic.lua              -- nvim-navic winbar breadcrumbs
  ui.lua                 -- lualine statusline + bufferline tabs (track :colorscheme)
  ui-polish.lua          -- nvim-notify + dressing.nvim
  ai.lua                 -- sidekick.nvim (jetski/copilot CLI workflow)
```

## Colorschemes

gruvbox loads by default. Switch live with `:colorscheme tokyonight`
(also `catppuccin`, `kanagawa`); both the statusline and bufferline track
whatever is active. To make a choice permanent, edit the final
`vim.cmd.colorscheme` line in `lua/plugins/colorscheme.lua`.

## Hotkeys

Leader is `<space>`. Plugin maps live with their plugin spec; globals are in
`lua/config/keymaps.lua`. which-key shows these on a short leader delay.

### Navigation & windows

| Key | Action |
| --- | --- |
| `<A-h/j/k/l>` | Move to window left/down/up/right (works in terminals too) |
| `<A-H/J/K/L>` | Resize window left/down/up/right |
| `gd` / `gr` / `gi` | LSP go to definition / references / implementation |
| `K` | LSP hover docs |
| `[d` / `]d` | Previous / next diagnostic |

### Buffers & tabs

| Key | Action |
| --- | --- |
| `<leader>bn` / `<leader>bp` | Next / previous buffer |
| `<leader>bd` | Delete buffer |
| `<leader>g` | Goto buffer by name (telescope) |
| `gC` / `gc` | Open new tab (with path) / close tab |

### Find (telescope)

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |
| `<leader>ft` | Find TODOs |

### Files, code & git

| Key | Action |
| --- | --- |
| `<leader>e` | Toggle file explorer (neo-tree) |
| `<leader>o` | Focus file explorer |
| `<leader>rn` | LSP rename symbol |
| `<leader>ca` | LSP code action |
| `<leader>lf` | Format buffer (conform) |
| `<leader>hs` / `<leader>hr` | Stage / reset git hunk |
| `<leader>hp` / `<leader>hb` | Preview hunk / blame line |
| `<leader>Gg` / `<leader>Gj` | Floating lazygit / jj TUI |

### Terminals & AI

| Key | Action |
| --- | --- |
| `<C-t>` | Toggle horizontal terminal |
| `<C-\>` | Toggle floating terminal |
| `<leader>th` / `<leader>tf` | Horizontal / floating terminal |
| `<C-a>` | Toggle AI agent (sidekick) |
| `<C-s>` | Select AI agent |
| `<leader>sc` / `<leader>sj` | Toggle Claude / Jetski |
| `<leader>sv` | Send visual selection to agent |

### Editing

| Key | Action |
| --- | --- |
| `<leader>z` | Toggle fold (normal) / create fold (visual) |
| `<C-j>` | Run `:make` |
| `<Esc>` | Clear search highlight |
| `<` / `>` (visual) | Indent, keeping the selection |

> Note: `<leader>e` is the file-explorer toggle globally, but in LSP-attached
> buffers it's remapped to "line diagnostics" (`lua/plugins/lsp.lua`), so it
> shows diagnostics there rather than toggling the tree.

## Plugin versions

Versions are pinned in `lazy-lock.json` (committed). To update:

```
:Lazy update      # then commit the updated lazy-lock.json
```

To reproduce the locked versions on a fresh machine: `:Lazy restore`.

## Install

This dir is stowed (`make stow` from the dotfiles root) to `~/.config/nvim`.
First launch bootstraps lazy.nvim and installs everything; `:Mason` installs the
language servers/formatters.
