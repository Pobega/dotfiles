-- Standalone linters via nvim-lint, complementing LSP diagnostics. Replaces the
-- linting half of AstroNvim's none-ls. Python/Rust already get rich diagnostics
-- from ruff/rust_analyzer, so only the gaps are filled here.
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  config = function()
    local lint = require "lint"
    lint.linters_by_ft = {
      lua = { "selene" }, -- uses the selene.toml in this config
      sh = { "shellcheck" },
      bash = { "shellcheck" },
    }

    -- Lint on the events below (after entering/writing a buffer).
    local group = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = group,
      callback = function()
        if not vim.bo.modifiable then return end
        -- Only run linters whose binary is installed, so a missing tool is a
        -- no-op instead of an error on every save.
        local names = lint.linters_by_ft[vim.bo.filetype] or {}
        local runnable = {}
        for _, name in ipairs(names) do
          local cfg = lint.linters[name]
          local cmd = type(cfg) == "table" and cfg.cmd or name
          if vim.fn.executable(cmd) == 1 then table.insert(runnable, name) end
        end
        if #runnable > 0 then lint.try_lint(runnable) end
      end,
    })
  end,
}
