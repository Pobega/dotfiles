local M = {}

M.toggle = function()
  local sidekick = require "sidekick.cli"
  if vim.fn.executable "copilot" == 1 then
    sidekick.toggle { name = "copilot", focus = true }
  elseif vim.fn.executable "claude" == 1 then
    sidekick.toggle { name = "claude", focus = true }
  else
    sidekick.toggle { name = "gemini", focus = true }
  end
end

return M
