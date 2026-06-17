-- Breadcrumbs in the winbar (cursor's location in the code structure), the way
-- AstroNvim showed via heirline+navic. Only shown where an LSP provides symbols.
return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  event = "LspAttach",
  config = function()
    local navic = require "nvim-navic"
    navic.setup {
      highlight = true,
      separator = " \u{f0142} ", -- chevron-right
      depth_limit = 5,
      lsp = { auto_attach = true }, -- attach to any server with documentSymbolProvider
    }

    local winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    -- Toggle the winbar per-window based on whether navic has data, so plain
    -- buffers (no LSP) don't get a blank winbar line.
    vim.api.nvim_create_autocmd({ "LspAttach", "BufWinEnter", "CursorMoved", "WinEnter" }, {
      group = vim.api.nvim_create_augroup("navic_winbar", { clear = true }),
      callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then return end -- skip terminals/prompts
        local ok = navic.is_available(args.buf)
        vim.wo.winbar = ok and winbar or nil
      end,
    })
  end,
}
