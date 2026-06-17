-- UI polish carried over from AstroNvim: toast notifications and nicer
-- vim.ui.select / vim.ui.input popups. Purely cosmetic.
return {
  -- Toast-style notifications, with history via :Telescope notify
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      render = "compact",
      stages = "fade",
      max_width = 60,
      background_colour = "#000000",
    },
    config = function(_, opts)
      local notify = require "notify"
      notify.setup(opts)
      vim.notify = notify
      pcall(function() require("telescope").load_extension "notify" end)
    end,
  },

  -- Floating, fuzzy-searchable replacements for vim.ui.select / vim.ui.input,
  -- used by LSP rename (<leader>rn), code actions (<leader>ca), etc.
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
