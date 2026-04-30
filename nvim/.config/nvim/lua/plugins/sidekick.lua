return {
  "folke/sidekick.nvim",
  opts = function()
    local gemini_path = "/google/bin/releases/gemini-cli/tools/gemini"
    local gemini_cmd = vim.fn.executable(gemini_path) == 1 and gemini_path or "gemini"

    return {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
        tools = {
          gemini = {
            cmd = { gemini_cmd },
          },
          nanocoder = {
            cmd = { "nanocoder" },
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
