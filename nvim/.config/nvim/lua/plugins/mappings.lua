return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        -- Buffer hotkeys
        ["<leader>bn"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
        ["<C-t>"] = { "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal" },
        ["<C-a>"] = { function() require("utils.agents").toggle() end, desc = "Toggle AI Agent" },
        ["<Leader>s"] = { desc = " Sidekick" },
        ["<leader>sa"] = { function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI", },
        ["<leader>ss"] = { function() require("sidekick.cli").select() end, desc = "Select CLI", },
        ["<leader>sd"] = { function() require("sidekick.cli").close() end, desc = "Detach a CLI Session", },
        ["<leader>st"] = { function() require("sidekick.cli").send({ msg = "{this}" }) end, desc = "Send This", },
        ["<leader>sf"] = { function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Send File", },
        ["<leader>sp"] = { function() require("sidekick.cli").prompt() end, desc = "Sidekick Select Prompt", },
        ["<leader>sc"] = { function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end, desc = "Sidekick Toggle Copilot", },
        ["<leader>sg"] = { function() require("sidekick.cli").toggle({ name = "gemini", focus = true }) end, desc = "Sidekick Toggle Gemini", },
      },
      t = {
        ["<C-t>"] = { "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal" },
        ["<C-a>"] = { function() require("utils.agents").toggle() end, desc = "Toggle AI Agent" },
      },
      v = {
        ["<Leader>s"] = { desc = " Sidekick" },
        ["<leader>st"] = { function() require("sidekick.cli").send({ msg = "{this}" }) end, desc = "Send This", },
        ["<leader>sv"] = { function() require("sidekick.cli").send({ msg = "{selection}" }) end, desc = "Send Visual Selection", },
      },
    },
  },
}
