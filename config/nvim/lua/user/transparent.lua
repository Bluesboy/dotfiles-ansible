local status_ok, transparent = pcall(require, "transparent")
if not status_ok then
  return
end

transparent.clear_prefix("NvimTree")

transparent.clear_prefix("lualine")
