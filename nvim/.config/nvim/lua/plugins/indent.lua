-- Indent guides. Restores the vertical indent lines AstroNvim showed.
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = { char = "│" },
    scope = { enabled = true, show_start = false, show_end = false },
    exclude = {
      filetypes = {
        "help",
        "lazy",
        "mason",
        "neo-tree",
        "Trouble",
        "toggleterm",
        "gitcommit",
      },
    },
  },
}
