-- Statusline. Replaces the hand-rolled `set statusline+=...` from the vimrc.
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "gruvbox",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
      },
    },
  },

  -- Buffer tabs across the top, the way AstroNvim's heirline tabline did it.
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      -- gruvbox palette (see gruvbox.nvim/lua/gruvbox.lua)
      local c = {
        bg = "#282828", -- dark0
        bg2 = "#3c3836", -- dark1 (inactive tab)
        bg3 = "#504945", -- dark2 (active tab, lighter so it pops)
        fg = "#ebdbb2", -- light1
        dim = "#a89984", -- light4
        yellow = "#fabd2f",
        orange = "#fe8019",
        red = "#fb4934",
      }
      local sel = { bg = c.bg3 }
      return {
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = "thin",
          indicator = { style = "icon", icon = "▎" },
        },
        -- Make the active tab a bold, bright accent block like lualine's bottom
        -- bar; keep inactive tabs dim so the current buffer stands out.
        highlights = {
          fill = { bg = c.bg },
          -- inactive tabs blend into the bar (no grey box) so only the active
          -- tab reads as a lit block
          background = { fg = c.dim, bg = c.bg },
          buffer_visible = { fg = c.dim, bg = c.bg },
          buffer_selected = { fg = c.yellow, bg = c.bg3, bold = true, italic = false },
          numbers_selected = { fg = c.yellow, bg = c.bg3, bold = true },
          indicator_selected = { fg = c.orange, bg = c.bg3 },
          indicator_visible = { fg = c.bg, bg = c.bg },
          modified = { fg = c.orange, bg = c.bg },
          modified_visible = { fg = c.orange, bg = c.bg },
          modified_selected = { fg = c.orange, bg = c.bg3 },
          separator = { fg = c.bg, bg = c.bg },
          separator_visible = { fg = c.bg, bg = c.bg },
          separator_selected = { fg = c.bg, bg = c.bg3 },
          diagnostic_selected = { fg = c.yellow, sp = c.yellow, bold = true, bg = c.bg3 },
          error_selected = { fg = c.red, sp = c.red, bold = true, bg = c.bg3 },
          warning_selected = { fg = c.yellow, sp = c.yellow, bold = true, bg = c.bg3 },
        },
      }
    end,
  },
}
