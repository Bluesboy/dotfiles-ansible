local M = {}

local function pane_count()
  local out = vim.fn.system("tmux list-panes -F '#{pane_id}'")
  local n = 0
  for _ in out:gmatch("[^\n]+") do
    n = n + 1
  end
  return n
end

local function bottom_pane_cmd()
  local out = vim.fn.system("tmux list-panes -F '#{pane_current_command}'")
  local lines = {}
  for line in out:gmatch("[^\n]+") do
    table.insert(lines, line)
  end
  return lines[2]
end

function M.open_or_focus()
  if vim.env.TMUX == nil then
    return
  end

  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end

  if pane_count() < 2 then
    vim.fn.system("tmux split-window -v -l 15")
    vim.fn.system("tmux send-keys -t 2 'cd " .. vim.fn.shellescape(dir) .. "' C-m")
  else
    local cmd = bottom_pane_cmd()
    if cmd == "fish" then
      vim.fn.system("tmux send-keys -t 2 'cd " .. vim.fn.shellescape(dir) .. "' C-m")
    end
    vim.fn.system("tmux select-pane -t 2")
  end
end

return M
