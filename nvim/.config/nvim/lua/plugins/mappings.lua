return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        -- Buffer hotkeys
        ["<leader>bn"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
        -- CodeCompanion Hotkeys
        ["<Leader>a"] = { desc = "CodeCompanion" },
        ["<leader>aa"] = { "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Action Palette" },
        ["<leader>ac"] = { "<cmd>CodeCompanionChat<cr>", desc = "Code Companion Chat Window" },
      },
    },
  },
}
