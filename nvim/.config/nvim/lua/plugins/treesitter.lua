-- Treesitter: syntax, indentation, folding. Replaces the per-language syntax
-- plugins (python-syntax, rust.vim highlighting, starlark.vim) from the old
-- vim config.
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "rust",
      "python",
      "starlark",
      "bash",
      "javascript",
      "typescript",
      "tsx",
      "markdown",
      "markdown_inline",
      "json",
      "yaml",
      "toml",
      "git_config",
      "gitcommit",
      "diff",
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
