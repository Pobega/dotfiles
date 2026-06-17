-- Format-on-save via conform.nvim. Covers the formatters the old config cared
-- about: rustfmt (rust.vim's g:rustfmt), ruff for Python, buildifier for
-- Starlark/Bazel, stylua for this config itself (.stylua.toml is committed).
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function() require("conform").format { async = true, lsp_format = "fallback" } end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
      bzl = { "buildifier" },
      starlark = { "buildifier" },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  },
}
