-- Global keymaps. Plugin-specific maps live with their plugin spec.
local map = vim.keymap.set

-- Code folding (carried from the old vimrc): <space> toggles, but <space> is
-- also leader, so use it only where it doesn't clash. Old config used <space>
-- for `za`; since leader is now <space>, fold toggling moves to `<leader>z`.
map("n", "<leader>z", "za", { desc = "Toggle fold" })
map("v", "<leader>z", "zf", { desc = "Create fold" })

-- Tab management (old gC/gc)
map("n", "gC", ":tabedit ", { desc = "Open new tab (with path)" })
map("n", "gc", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Run :make (old <C-j>)
map("n", "<C-j>", "<cmd>make<cr>", { desc = "Run make" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Buffer management (jump to a buffer by name with <leader>g, see editor.lua)
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Keep visual selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
