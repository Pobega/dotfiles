-- gruvbox, matching the old vim/.vim setup.
return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000, -- load before everything else
  lazy = false,
  opts = {
    transparent_mode = true, -- old config used `hi Normal ctermbg=none`
    contrast = "hard",
  },
  config = function(_, opts)
    require("gruvbox").setup(opts)

    -- gruvbox hard-codes WhichKeyGroup to red, which makes the which-key group
    -- titles look like errors. Link it to WhichKeyDesc (the blue used for leaf
    -- entry descriptions) so groups match the rest. Reapply on every colorscheme
    -- load since gruvbox resets it.
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("whichkey_group_color", { clear = true }),
      pattern = "gruvbox",
      callback = function() vim.api.nvim_set_hl(0, "WhichKeyGroup", { link = "WhichKeyDesc" }) end,
    })

    vim.cmd.colorscheme "gruvbox"
  end,
}
