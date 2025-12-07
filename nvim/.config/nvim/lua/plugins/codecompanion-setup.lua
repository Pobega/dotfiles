return {
  require("codecompanion").setup({
    strategies = {
      inline = {
        adapter = "copilot",
      },
      inline = {
        adapter = "gemini_cli",
      },
    },
    adapters = {
      acp = {
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            defaults = {
              auth_method = "gemini-api-key",
            },
--            env = {
--              GEMINI_API_KEY = "cmd:op read op://personal/Gemini_API/credential --no-newline",
--            },
          })
        end,
      },
    },
  }),
}
