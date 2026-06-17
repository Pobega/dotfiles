-- Entry point. Leader must be set before lazy.nvim loads so plugin mappings
-- pick up the right prefix.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require "config.options"
require "config.keymaps"
require "config.autocmds"
require "config.lazy"
