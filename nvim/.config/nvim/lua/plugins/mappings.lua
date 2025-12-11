return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        -- Buffer hotkeys
        ["<leader>bn"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
        -- CodeCompanion Hotkeys
        ["<Leader>a"] = { desc = " CodeCompanion" },
        ["<leader>aa"] = { "<cmd>CodeCompanion<cr>", desc = "Code Companion Prompt" },
        ["<leader>as"] = { "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Action Palette" },
        ["<leader>ac"] = { "<cmd>CodeCompanionChat<cr>", desc = "Code Companion Chat Window" },
        ["<leader>s"] = { desc = "󰁤 Sidekick" },
        ["<leader>sa"] = { function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI", },
        ["<leader>ss"] = { function() require("sidekick.cli").select() end, desc = "Select CLI", },
        ["<leader>sd"] = { function() require("sidekick.cli").close() end, desc = "Detach a CLI Session", },
        ["<leader>st"] = { function() require("sidekick.cli").send({ msg = "{this}" }) end, desc = "Send This", },
        ["<leader>sf"] = { function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Send File", },
        ["<leader>sp"] = { function() require("sidekick.cli").prompt() end, desc = "Sidekick Select Prompt", },
        ["<leader>sc"] = { function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end, desc = "Sidekick Toggle Copilot", },
      },
      v = {
        ["<Leader>a"] = { desc = " CodeCompanion" },
        -- TODO: aa currently does not work as the buffer isn't properly sent into it.
        ["<leader>aa"] = { "<cmd>CodeCompanion<cr>", desc = "Code Companion Prompt" },
        ["<leader>as"] = { "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Action Palette" },
        ["<leader>ac"] = { "<cmd>CodeCompanionChat<cr>", desc = "Code Companion Chat Window" },
        ["<leader>s"] = { desc = "󰁤 Sidekick" },
        ["<leader>st"] = { function() require("sidekick.cli").send({ msg = "{this}" }) end, desc = "Send This", },
        ["<leader>sv"] = { function() require("sidekick.cli").send({ msg = "{selection}" }) end, desc = "Send Visual Selection", },
      },
    },
  },
}
