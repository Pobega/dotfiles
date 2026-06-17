-- General editor tooling: fuzzy finding, which-key, vim-aware split navigation
-- (carried from your jetski/tmux setup), terminal toggling, and the small
-- quality-of-life plugins you already used in vim (sleuth).
return {
  -- vim-sleuth: auto-detect shiftwidth/expandtab (was a submodule in vim)
  { "tpope/vim-sleuth", event = { "BufReadPre", "BufNewFile" } },

  -- Telescope: fuzzy finder for files / grep / buffers
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      -- goto buffer: type the buffer name to jump to it (most-recent first)
      {
        "<leader>g",
        function() require("telescope.builtin").buffers { sort_mru = true, ignore_current_buffer = true } end,
        desc = "Goto buffer (by name)",
      },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      -- old :todo abbreviation, modernised
      { "<leader>ft", "<cmd>Telescope grep_string search=TODO<cr>", desc = "Find TODOs" },
    },
    config = function()
      require("telescope").setup {}
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- which-key: discoverable leader mappings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- Name the leader group prefixes so the popup isn't full of bare keys,
      -- and give each an icon/color instead of the default red group styling.
      -- Icons are Nerd Font Material Design glyphs, written as \u{} escapes so
      -- they survive editing regardless of the tooling's unicode handling.
      spec = {
        { "<leader>b", group = "Buffers", icon = { icon = "\u{f04e9}", color = "cyan" } }, -- tabs
        { "<leader>c", group = "Code", icon = { icon = "\u{f0169}", color = "orange" } }, -- code tags
        { "<leader>f", group = "Find", icon = { icon = "\u{f0349}", color = "blue" } }, -- magnify
        { "<leader>G", group = "Git (TUI)", icon = { icon = "\u{f02a2}", color = "orange" } }, -- git
        { "<leader>h", group = "Git Hunks", icon = { icon = "\u{f02a2}", color = "orange" } }, -- git
        { "<leader>l", group = "LSP", icon = { icon = "\u{f0493}", color = "green" } }, -- cog
        { "<leader>r", group = "Refactor", icon = { icon = "\u{f03eb}", color = "purple" } }, -- pencil
        { "<leader>s", group = "Sidekick", icon = { icon = "\u{f06a9}", color = "green" } }, -- robot
        { "<leader>t", group = "Terminal", icon = { icon = "\u{f018d}", color = "green" } }, -- console
      },
    },
  },

  -- smart-splits: vim-aware <A-hjkl> navigation + resize, matching your tmux
  -- jetski setup. Ported from the AstroNvim smart-splits.lua + mappings.lua.
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = { default_amount = 5 },
    keys = {
      -- navigation
      { "<A-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
      { "<A-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to lower window" },
      { "<A-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to upper window" },
      { "<A-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
      -- resize
      { "<A-H>", function() require("smart-splits").resize_left() end, desc = "Resize window left" },
      { "<A-J>", function() require("smart-splits").resize_down() end, desc = "Resize window down" },
      { "<A-K>", function() require("smart-splits").resize_up() end, desc = "Resize window up" },
      { "<A-L>", function() require("smart-splits").resize_right() end, desc = "Resize window right" },
      -- terminal-mode navigation (was the `t` block in mappings.lua)
      { "<A-h>", function() require("smart-splits").move_cursor_left() end, mode = "t", desc = "Move to left window" },
      { "<A-j>", function() require("smart-splits").move_cursor_down() end, mode = "t", desc = "Move to lower window" },
      { "<A-k>", function() require("smart-splits").move_cursor_up() end, mode = "t", desc = "Move to upper window" },
      { "<A-l>", function() require("smart-splits").move_cursor_right() end, mode = "t", desc = "Move to right window" },
    },
  },

  -- toggleterm: <C-t> horizontal terminal (matches old mappings.lua), plus a
  -- floating variant. Each direction gets its own terminal id so they can be
  -- open independently.
  {
    "akinsho/toggleterm.nvim",
    keys = {
      -- horizontal (id 1)
      { "<C-t>", "<cmd>1ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal (horizontal)" },
      { "<C-t>", "<cmd>1ToggleTerm direction=horizontal<cr>", mode = "t", desc = "Toggle terminal (horizontal)" },
      { "<leader>th", "<cmd>1ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
      -- floating (id 2)
      { "<C-\\>", "<cmd>2ToggleTerm direction=float<cr>", desc = "Toggle terminal (float)" },
      { "<C-\\>", "<cmd>2ToggleTerm direction=float<cr>", mode = "t", desc = "Toggle terminal (float)" },
      { "<leader>tf", "<cmd>2ToggleTerm direction=float<cr>", desc = "Floating terminal" },
    },
    opts = {
      open_mapping = nil,
      direction = "horizontal",
      float_opts = { border = "curved" },
    },
  },
}
