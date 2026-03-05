local M = {}

function M.insert_description()
  local pkg = vim.fn.expand("<cWORD>")
  pkg = pkg:gsub("^%-+", ""):gsub("#.*", "")
  local line = vim.api.nvim_get_current_line()

  if line:find("#") then
    print("Line already has comment")
    return
  end

  local cmd = "paru -Si " .. pkg
  local info = vim.fn.system(cmd)

  -- local desc = info:match("Description%s*:%s*(.-)\n")
  local desc
  for l in info:gmatch("[^\r\n]+") do
    desc = l:match("^%s*Description%s*:%s*(.+)")
    if desc then
      break
    end
  end

  if desc then
    vim.api.nvim_set_current_line(line .. " # " .. desc)
  else
    print("AUR description not found")
  end
end

return M
