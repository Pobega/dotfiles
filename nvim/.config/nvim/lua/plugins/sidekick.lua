return {
  "folke/sidekick.nvim",
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
        }
      }
    }
  end,
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-\\>",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
  },
}
