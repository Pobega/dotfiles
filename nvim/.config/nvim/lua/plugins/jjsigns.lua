return {
  "evanphx/jjsigns.nvim",
  enabled = vim.fn.executable "jj" == 1,
  event = "User AstroFile",
  opts = {},
}
