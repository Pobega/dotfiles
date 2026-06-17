-- Auto-close brackets, quotes, etc. Restores the AstroNvim autopairs behaviour.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- use treesitter to avoid pairing in the wrong context
  },
  config = function(_, opts)
    local autopairs = require "nvim-autopairs"
    autopairs.setup(opts)

    -- When a function/method is completed, add the parentheses too.
    local ok, cmp = pcall(require, "cmp")
    if ok then
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end
  end,
}
