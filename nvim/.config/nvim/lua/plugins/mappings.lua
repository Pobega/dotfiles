return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        -- Window navigation (using smart-splits)
        ["<C-h>"] = { function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
        ["<C-j>"] = { function() require("smart-splits").move_cursor_down() end, desc = "Move to lower window" },
        ["<C-k>"] = { function() require("smart-splits").move_cursor_up() end, desc = "Move to upper window" },
        ["<C-l>"] = { function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
        -- Buffer hotkeys
        ["<leader>bn"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
        ["<C-t>"] = { "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal" },
        ["<C-a>"] = { function() require("sidekick.cli").toggle() end, desc = "Toggle AI Agent" },
        ["<C-s>"] = { function() require("sidekick.cli").select() end, desc = "Select AI Agent" },
        ["<Leader>s"] = { desc = " Sidekick" },
        ["<leader>sa"] = { function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI", },
        ["<leader>ss"] = { function() require("sidekick.cli").select() end, desc = "Select CLI", },
        ["<leader>sd"] = { function() require("sidekick.cli").close() end, desc = "Detach a CLI Session", },
        ["<leader>st"] = { function() require("sidekick.cli").send({ msg = "{this}" }) end, desc = "Send This", },
        ["<leader>sf"] = { function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Send File", },
        ["<leader>sp"] = { function() require("sidekick.cli").prompt() end, desc = "Sidekick Select Prompt", },
        ["<leader>sc"] = { function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end, desc = "Sidekick Toggle Copilot", },
        ["<leader>sg"] = { function() require("sidekick.cli").toggle({ name = "gemini", focus = true }) end, desc = "Sidekick Toggle Gemini", },
      },
      t = {
        -- Window navigation (using smart-splits)
        ["<C-h>"] = { function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
        ["<C-j>"] = { function() require("smart-splits").move_cursor_down() end, desc = "Move to lower window" },
        ["<C-k>"] = { function() require("smart-splits").move_cursor_up() end, desc = "Move to upper window" },
        ["<C-l>"] = { function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
        ["<C-t>"] = { "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal" },
        ["<C-a>"] = { function() require("utils.agents").hide_current() end, desc = "Hide current AI Agent" },
      },
      v = {
        ["<Leader>s"] = { desc = " Sidekick" },
        ["<leader>st"] = { function() require("sidekick.cli").send({ msg = "{this}" }) end, desc = "Send This", },
        ["<leader>sv"] = { function() require("sidekick.cli").send({ msg = "{selection}" }) end, desc = "Send Visual Selection", },
      },
    },
  },
}
