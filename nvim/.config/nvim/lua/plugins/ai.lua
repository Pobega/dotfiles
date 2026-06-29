-- AI CLI integration via sidekick.nvim, carried over from the AstroNvim setup
-- so the jetski/copilot workflow keeps working. Mappings ported from the old
-- mappings.lua (the <C-a> "hide current" terminal map there relied on a small
-- utils.agents helper; sidekick's own toggle covers the common case).
return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = function()
    local jetski_path = "/google/bin/releases/jetski-devs/tools/cli"
    local jetski_cmd = vim.fn.executable(jetski_path) == 1 and jetski_path or "jetski"

    return {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
        tools = {
          nanocoder = {
            cmd = { "nanocoder" },
          },
          jetski = {
            cmd = { jetski_cmd },
          },
        },
      },
    }
  end,
  config = function(_, opts)
    require("sidekick").setup(opts)
    -- Remove codex from the resolved config to prevent it from being suggested
    -- if an unrelated binary named "codex" exists in the system PATH.
    pcall(function()
      require("sidekick.config").cli.tools.codex = nil
    end)
  end,
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
