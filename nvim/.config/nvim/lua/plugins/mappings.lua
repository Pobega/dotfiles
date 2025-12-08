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
        ["<leader>aa"] = { "<cmd>CodeCompanion<cr>", desc = "Code Companion Prompt" },
        ["<leader>as"] = { "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Action Palette" },
        ["<leader>ac"] = { "<cmd>CodeCompanionChat<cr>", desc = "Code Companion Chat Window" },
      },
      v = {
        -- CodeCompanion Visual Mode Hotkeys
        -- TODO: These currently do not work as the buffer isn't properly sent into them.
        -- The goal here is to have the buffer silently passed in visual mode, but have the
        -- user only see the 'Prompt' popup (for example.)
        ["<Leader>a"] = { desc = "CodeCompanion" },
        ["<leader>aa"] = { "<cmd>CodeCompanion<cr>", desc = "Code Companion Prompt" },
        ["<leader>as"] = { "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Action Palette" },
        ["<leader>ac"] = { "<cmd>CodeCompanionChat<cr>", desc = "Code Companion Chat Window" },
      },
    },
  },
}
