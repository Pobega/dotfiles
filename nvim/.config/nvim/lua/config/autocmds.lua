-- Autocommands, ported from the old vimrc.
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight trailing whitespace as an error, but only in normal editable files.
-- Uses window-local state to prevent highlights from leaking into terminals/special buffers.
autocmd({ "BufWinEnter", "InsertLeave", "TermOpen" }, {
  group = augroup("trailing_whitespace", { clear = true }),
  callback = function()
    -- Clear any existing whitespace match in this window to prevent leaks
    if vim.w.whitespace_match then
      pcall(vim.fn.matchdelete, vim.w.whitespace_match)
      vim.w.whitespace_match = nil
    end

    -- Only add the highlight if it's a normal file buffer and it is modifiable
    if vim.bo.modifiable and vim.bo.buftype == "" then
      vim.w.whitespace_match = vim.fn.matchadd("DiffDelete", [[\s\+$]])
    end
  end,
})

-- Git commit messages: spell check + 72 col textwidth
autocmd("FileType", {
  group = augroup("gitcommit_settings", { clear = true }),
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
  end,
})

-- Always treat makefile* as a makefile (old filetype_custom group)
autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("makefile_detect", { clear = true }),
  pattern = "makefile*",
  callback = function() vim.bo.filetype = "make" end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Launch the file picker when nvim is opened with no file (e.g. bare `nvim`).
-- Skips when a file/dir argument is given, input is piped in, or a session is
-- being restored.
autocmd("VimEnter", {
  group = augroup("find_files_on_empty", { clear = true }),
  callback = function()
    if vim.fn.argc() > 0 then return end -- a file/dir was passed
    if vim.g.read_from_stdin then return end -- something was piped in
    local buf = vim.api.nvim_get_current_buf()
    -- only act on the default empty scratch buffer
    if vim.api.nvim_buf_get_name(buf) ~= "" then return end
    if vim.bo[buf].filetype ~= "" then return end
    vim.schedule(function() require("telescope.builtin").find_files() end)
  end,
})

-- Track piped input so the picker autocmd above can bail on `... | nvim -`
autocmd("StdinReadPre", {
  group = augroup("find_files_on_empty", { clear = false }),
  callback = function() vim.g.read_from_stdin = true end,
})
