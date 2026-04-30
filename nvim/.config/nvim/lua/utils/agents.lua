local M = {}

-- Hide the specific sidekick agent whose terminal buffer we're currently in.
-- Falls back to a generic toggle if we can't identify the current agent.
M.hide_current = function()
  local sidekick = require("sidekick.cli")
  local tool = vim.b[0].sidekick_cli
  if tool and tool.name then
    sidekick.hide({ name = tool.name })
  else
    sidekick.toggle()
  end
end

return M
