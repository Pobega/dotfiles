-- LSP: mason installs the servers, nvim-lspconfig wires them up. This is the
-- big thing the old vim config never had (it leaned on keywordprg=:LspHover
-- via vim's built-in lsp client). Covers the languages from the vim config:
-- Rust, Python, Lua, plus Starlark formatting via buildifier (see conform).
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },
  -- Auto-install the formatters/linters referenced by conform & nvim-lint.
  -- LSP servers are handled separately by mason-lspconfig; rustfmt ships with
  -- rustup so it's intentionally omitted.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "stylua", -- lua formatter (conform)
        "buildifier", -- starlark/bazel formatter (conform)
        "selene", -- lua linter (nvim-lint)
        "shellcheck", -- bash linter (nvim-lint)
      },
      run_on_start = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Buffer-local keymaps once a server attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local function nmap(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
          end
          nmap("gd", vim.lsp.buf.definition, "Go to definition")
          nmap("gr", vim.lsp.buf.references, "References")
          nmap("gi", vim.lsp.buf.implementation, "Go to implementation")
          nmap("K", vim.lsp.buf.hover, "Hover docs") -- old `keywordprg=:LspHover`
          nmap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
          nmap("[d", function() vim.diagnostic.jump { count = -1 } end, "Prev diagnostic")
          nmap("]d", function() vim.diagnostic.jump { count = 1 } end, "Next diagnostic")
          nmap("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })

      vim.diagnostic.config {
        virtual_text = true,
        underline = true,
        severity_sort = true,
      }

      -- Advertise nvim-cmp completion capabilities to servers.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        rust_analyzer = {},
        pyright = {},
        ruff = {},
        eslint = {
          -- run `eslint --fix` on save for JS/TS buffers
          on_attach = function(_, buf)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = buf,
              command = "EslintFixAll",
            })
          end,
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } }, -- matches selene.toml / neovim.yml
              workspace = { checkThirdParty = false },
            },
          },
        },
      }

      require("mason-lspconfig").setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }

      for name, cfg in pairs(servers) do
        cfg.capabilities = capabilities
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end
    end,
  },
}
