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
  colorscheme.lua        -- gruvbox (transparent, hard contrast)
  treesitter.lua         -- syntax/indent/fold for lua, rust, python, starlark, ...
  lsp.lua                -- mason + nvim-lspconfig (rust_analyzer, pyright, ruff, lua_ls)
  completion.lua         -- nvim-cmp (replaces supertab)
  formatting.lua         -- conform.nvim (rustfmt, ruff, buildifier, stylua)
  git.lua                -- gitsigns, vim-fugitive, jjsigns
  editor.lua             -- telescope, which-key, smart-splits, toggleterm, vim-sleuth
  ui.lua                 -- lualine statusline
  ai.lua                 -- sidekick.nvim (jetski/copilot CLI workflow)
```

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
