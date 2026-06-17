-- Editor options. Mirrors the intent of the old vim/.vim/vimrc, translated to
-- Neovim defaults (many old settings like `nocompatible`, `t_Co`, `syntax on`,
-- `laststatus=2` are already the default in Neovim).
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Cursor highlight (was CursorColumn/CursorLine in the vimrc)
opt.cursorline = true
opt.cursorcolumn = true

-- Line wrapping at word boundaries with hanging indent (carried over from the
-- AstroNvim init.lua tweaks)
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- Use the system clipboard directly. Replaces the old xclip Y/P hacks.
opt.clipboard = "unnamedplus"

-- Sensible search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Indentation (vim-sleuth still adjusts per-file; these are the fallbacks)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Always show the sign column so gitsigns/diagnostics don't shift text
opt.signcolumn = "yes"

-- Faster update for gitsigns / diagnostics
opt.updatetime = 250

-- Mouse off, matching the old config
opt.mouse = ""

-- Buffer/window behaviour
opt.splitbelow = true
opt.splitright = true
opt.switchbuf = "usetab,newtab"

-- Quiet completion messages
opt.shortmess:append "c"

-- Persistent undo
opt.undofile = true

-- Project-local config files, secured (set exrc / secure in old vimrc)
opt.exrc = true

-- True color for gruvbox
opt.termguicolors = true
opt.background = "dark"

-- Transparent background friendliness is handled by the colorscheme spec.
