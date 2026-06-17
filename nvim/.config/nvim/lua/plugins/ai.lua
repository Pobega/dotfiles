-- AI CLI integration via sidekick.nvim, carried over from the AstroNvim setup
-- so the jetski/copilot workflow keeps working. Mappings ported from the old
-- mappings.lua (the <C-a> "hide current" terminal map there relied on a small
-- utils.agents helper; sidekick's own toggle covers the common case).
return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<C-a>", function() require("sidekick.cli").toggle() end, desc = "Toggle AI Agent" },
    { "<C-s>", function() require("sidekick.cli").select() end, desc = "Select AI Agent" },
    { "<leader>sa", function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI" },
    { "<leader>ss", function() require("sidekick.cli").select() end, desc = "Select CLI" },
    { "<leader>sd", function() require("sidekick.cli").close() end, desc = "Detach a CLI Session" },
    { "<leader>st", function() require("sidekick.cli").send { msg = "{this}" } end, desc = "Send This" },
    { "<leader>sf", function() require("sidekick.cli").send { msg = "{file}" } end, desc = "Send File" },
    { "<leader>sp", function() require("sidekick.cli").prompt() end, desc = "Sidekick Select Prompt" },
    {
      "<leader>sc",
      function() require("sidekick.cli").toggle { name = "claude", focus = true } end,
      desc = "Toggle Claude",
    },
    {
      "<leader>sj",
      function() require("sidekick.cli").toggle { name = "jetski", focus = true } end,
      desc = "Toggle Jetski",
    },
    {
      "<leader>sv",
      function() require("sidekick.cli").send { msg = "{selection}" } end,
      mode = "v",
      desc = "Send Visual Selection",
    },
  },
}
