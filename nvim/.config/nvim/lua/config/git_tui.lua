-- Helper for launching git/jj TUIs in a cached floating toggleterm terminal.
local M = {}

-- Cache one Terminal per command so toggling reuses the same instance.
local terminals = {}

local function get_terminal(cmd)
  if not terminals[cmd] then
    local Terminal = require("toggleterm.terminal").Terminal
    terminals[cmd] = Terminal:new {
      cmd = cmd,
      direction = "float",
      hidden = true,
      float_opts = { border = "curved" },
      -- close the floating window automatically when the TUI exits
      on_exit = function() terminals[cmd] = nil end,
    }
  end
  return terminals[cmd]
end

-- Toggle a single TUI by command name; warn if it isn't installed.
function M.toggle(cmd)
  if vim.fn.executable(cmd) ~= 1 then
    vim.notify(cmd .. " is not installed", vim.log.levels.WARN, { title = "git TUI" })
    return
  end
  get_terminal(cmd):toggle()
end

-- Toggle the first installed command from a preference-ordered list.
function M.toggle_first(cmds)
  for _, cmd in ipairs(cmds) do
    if vim.fn.executable(cmd) == 1 then
      get_terminal(cmd):toggle()
      return
    end
  end
  vim.notify(
    "none installed: " .. table.concat(cmds, ", "),
    vim.log.levels.WARN,
    { title = "jj TUI" }
  )
end

return M
