-- Statusline + bufferline. Both track the active `:colorscheme`: lualine via
-- its "auto" theme, bufferline via a per-theme palette (re-applied on the
-- ColorScheme event). Switch themes live with e.g. `:colorscheme tokyonight`.

-- Hand-tuned palettes per colorscheme. gruvbox keeps the exact hex the bars
-- used before this was made swappable, so `:colorscheme gruvbox` reproduces the
-- original look. Unknown themes fall back to colors derived from highlight
-- groups (see palette()).
local palettes = {
  -- bg = bar background, sel = active-tab block, fg = text, dim = inactive text,
  -- accent = active-tab text, accent2 = indicator/modified, red = error.
  gruvbox = { bg = "#282828", sel = "#504945", fg = "#ebdbb2", dim = "#a89984", accent = "#fabd2f", accent2 = "#fe8019", red = "#fb4934" },
  tokyonight = { bg = "#1a1b26", sel = "#292e42", fg = "#c0caf5", dim = "#565f89", accent = "#7dcfff", accent2 = "#ff9e64", red = "#f7768e" },
  catppuccin = { bg = "#1e1e2e", sel = "#45475a", fg = "#cdd6f4", dim = "#6c7086", accent = "#cba6f7", accent2 = "#fab387", red = "#f38ba8" },
  kanagawa = { bg = "#1f1f28", sel = "#363646", fg = "#dcd7ba", dim = "#727169", accent = "#7e9cd8", accent2 = "#ffa066", red = "#e82424" },
}
-- Theme variants resolve to the same palette.
palettes["tokyonight-storm"] = palettes.tokyonight
palettes["tokyonight-night"] = palettes.tokyonight
palettes["tokyonight-moon"] = palettes.tokyonight
palettes["catppuccin-mocha"] = palettes.catppuccin
palettes["kanagawa-wave"] = palettes.kanagawa
palettes["kanagawa-dragon"] = palettes.kanagawa

local function hl_color(group, attr)
  local h = vim.api.nvim_get_hl(0, { name = group, link = false })
  return h and h[attr] and string.format("#%06x", h[attr]) or nil
end

-- Palette for the active colorscheme, falling back to highlight-group colors.
local function palette()
  local p = palettes[vim.g.colors_name or ""]
  if p then return p end
  return {
    bg = hl_color("Normal", "bg") or "#282828",
    fg = hl_color("Normal", "fg") or "#ebdbb2",
    sel = hl_color("PmenuSel", "bg") or hl_color("Visual", "bg") or "#504945",
    dim = hl_color("Comment", "fg") or "#a89984",
    accent = hl_color("Function", "fg") or "#fabd2f",
    accent2 = hl_color("Constant", "fg") or "#fe8019",
    red = hl_color("DiagnosticError", "fg") or "#fb4934",
  }
end

-- Active tab reads as a lit accent block; inactive tabs blend into the bar.
local function bufferline_highlights()
  local c = palette()
  return {
    fill = { bg = c.bg },
    background = { fg = c.dim, bg = c.bg },
    buffer_visible = { fg = c.dim, bg = c.bg },
    buffer_selected = { fg = c.accent, bg = c.sel, bold = true, italic = false },
    numbers_selected = { fg = c.accent, bg = c.sel, bold = true },
    indicator_selected = { fg = c.accent2, bg = c.sel },
    indicator_visible = { fg = c.bg, bg = c.bg },
    modified = { fg = c.accent2, bg = c.bg },
    modified_visible = { fg = c.accent2, bg = c.bg },
    modified_selected = { fg = c.accent2, bg = c.sel },
    separator = { fg = c.bg, bg = c.bg },
    separator_visible = { fg = c.bg, bg = c.bg },
    separator_selected = { fg = c.bg, bg = c.sel },
    diagnostic_selected = { fg = c.accent, sp = c.accent, bold = true, bg = c.sel },
    error_selected = { fg = c.red, sp = c.red, bold = true, bg = c.sel },
    warning_selected = { fg = c.accent, sp = c.accent, bold = true, bg = c.sel },
  }
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto", -- follows the active colorscheme
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
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
        indicator = { style = "icon", icon = "▎" },
      },
      -- Passed as a function so bufferline re-invokes it on every ColorScheme
      -- (it calls config.update_highlights, which re-runs this and resets the
      -- icon-highlight cache). That makes the whole bar -- text, indicators, and
      -- file-type icons -- track the active colorscheme in a single switch.
      highlights = bufferline_highlights,
    },
  },
}
