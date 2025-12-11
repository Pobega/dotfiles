return {
  require("codecompanion").setup({
    extensions = {
      spinner = {},
    },
    display = {
      diff = {
        provider_opts = {
          inline = {
            layout = "float", -- float|buffer - Where to display the diff
            opts = {
              context_lines = 3, -- Number of context lines in hunks
              dim = 25, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
              full_width_removed = true, -- Make removed lines span full width
              show_keymap_hints = true, -- Show "gda: accept | gdr: reject" hints above diff
              show_removed = true, -- Show removed lines as virtual text
            },
          },
        },
      },
      chat = {
        fold_context = false, -- Fold context messages in chat buffer
        window = {
          layout = "vertical", -- float|vertical|horizontal|buffer
          position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
          border = "single",
          height = 0.8,
          width = 0.40,
          relative = "editor",
          full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
          sticky = false, -- when set to true and `layout` is not `"buffer"`, the chat buffer will remain opened when switching tabs
          opts = {
            breakindent = true,
            cursorcolumn = false,
            cursorline = false,
            foldcolumn = "0",
            linebreak = true,
            list = false,
            numberwidth = 1,
            signcolumn = "no",
            spell = false,
            wrap = true,
          },
        },
        ---Customize how tokens are displayed
        ---@param tokens number
        ---@param adapter CodeCompanion.Adapter
        ---@return string
        token_count = function(tokens, adapter)
          return " (" .. tokens .. " tokens)"
        end,
      },
    },
    strategies = {
      inline = {
        adapter = "codestral",
        keymaps = {
          accept_change = {
            modes = { n = "ga" },
            description = "Accept the suggested change",
          },
          reject_change = {
            modes = { n = "gr" },
            opts = { nowait = true },
            description = "Reject the suggested change",
          },
          stop = {
            modes = { n = "q" },
            index = 4,
            callback = "keymaps.stop",
            description = "Stop request",
          },
        },
      },
      chat = {
        adapter = 'codestral',
        display = {
          chat = {
            intro_message = "Welcome to CodeCompanion ✨!\n Press ? for options",
            separator = "─", -- The separator between the different messages in the chat buffer
            show_context = true, -- Show context (from slash commands and variables) in the chat buffer?
            show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
            show_settings = true, -- Show LLM settings at the top of the chat buffer?
            show_token_count = true, -- Show the token count for each response?
            show_tools_processing = true, -- Show the loading message when tools are being executed?
            start_in_insert_mode = false, -- Open the chat buffer in insert mode?
          },
        },
        tools = {
          opts = {
            default_tools = { "full_stack_dev" },
            auto_submit_errors = true, -- Needed to use tools with Mistral
          },
        },
      },
    },
    adapters = {
      http = {
        opts = { show_defaults = false, },
        codestral = function()
          return require("codecompanion.adapters").extend("mistral", {
            name = "codestral",
            schema = {
              model = {
                default = 'codestral-latest'
              },
            },
            env = {
              api_key = "MISTRAL_API_KEY",
            },
          })
        end,
        mistral = function()
          return require("codecompanion.adapters").extend("mistral", {
            env = {
              api_key = "MISTRAL_API_KEY",
            },
          })
        end,
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {})
        end,
        anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          env = {
            api_key = "ANTHROPIC_API_KEY",
          },
        })
        end,
        gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "GEMINI_API_KEY",
          },
        })
        end,
      },
      acp = {
        opts = { show_defaults = false, },
        opencode = function()
          return require("codecompanion.adapters").extend("opencode", {
            env = {
              api_key = "MISTRAL_API_KEY",
            },
          })
        end,
      },
    },
  }),
}
