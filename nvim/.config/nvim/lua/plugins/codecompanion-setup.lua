return {
  require("codecompanion").setup({
    strategies = {
      inline = {
        adapter = "mistral",
        model = 'codestral-latest',
        keymaps = {
          accept_change = {
            modes = { n = "ga" },
            description = "Accept the suggested change",
          },
          reject_change = {
            modes = { n = "gr" },
            opts = { nowait = true },
            description = "Reject the suggested change",
          },
          stop = {
            modes = { n = "q" },
            index = 4,
            callback = "keymaps.stop",
            description = "Stop request",
          },
        },
      },
      chat = {
        adapter = 'mistral',
        model = 'codestral-latest',
        tools = {
          opts = {
            -- Needed to use tools in Mistral
            auto_submit_errors = true,
          },
        },
      },
    },
    adapters = {
      http = {
        mistral = function()
          return require("codecompanion.adapters").extend("mistral", {
            env = {
              api_key = "MISTRAL_API_KEY",
            },
          })
        end,
      },
      acp = {
        opts = { show_defaults = false, },
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            defaults = {
              auth_method = "gemini-api-key",
            },
            env = {
              api_key = "GEMINI_API_KEY",
            },
          })
        end,
      },
    },
  }),
}
