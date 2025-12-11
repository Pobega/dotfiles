return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ravitemer/mcphub.nvim",
    "franco-ruggeri/codecompanion-spinner.nvim",
    "j-hui/fidget.nvim",
    "saghen/blink.cmp",
    {
      "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
        opts = {
        render_modes = true,
        sign = {
          enabled = false,
        },
      },
    },
    "echasnovski/mini.diff",
    config = function()
	    local diff = require("mini.diff")
	    diff.setup({ source = diff.gen_source.none(), })
    end,
  },
  init = function()
    require("plugins.codecompanion.fidget-spinner"):init()
  end,
}
