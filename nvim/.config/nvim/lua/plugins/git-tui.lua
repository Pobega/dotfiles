-- Floating git/jj TUIs via toggleterm. Restores AstroNvim's lazygit and adds a
-- Jujutsu TUI alongside it (you run both git and jj for now). Lives under
-- <leader>G ("Git") since <leader>g is the goto-buffer picker.
return {
  "akinsho/toggleterm.nvim",
  keys = {
    {
      "<leader>Gg",
      function() require("config.git_tui").toggle "lazygit" end,
      desc = "Lazygit",
    },
    {
      "<leader>Gj",
      -- prefer jjui, fall back to lazyjj
      function() require("config.git_tui").toggle_first { "jjui", "lazyjj" } end,
      desc = "jj TUI",
    },
  },
}
