-- File explorer. Restores the neo-tree sidebar AstroNvim provided on <leader>e.
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    { "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
  },
  opts = {
    close_if_last_window = true,
    -- Close the sidebar as soon as a file is opened from it.
    event_handlers = {
      {
        event = "file_opened",
        handler = function() require("neo-tree.command").execute { action = "close" } end,
      },
    },
    filesystem = {
      follow_current_file = { enabled = true }, -- reveal the file you're editing
      use_libuv_file_watcher = true, -- refresh on external changes
      filtered_items = {
        hide_dotfiles = false, -- you live in a dotfiles repo
        hide_gitignored = true,
      },
    },
    window = {
      width = 32,
      mappings = {
        ["<space>"] = "none", -- don't shadow leader
      },
    },
  },
}
