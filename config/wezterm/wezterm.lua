local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("Ubuntu Mono Ligaturized", {
  weight = "Regular",
})
config.font_size = 14.5

config.enable_tab_bar = false

-- config.font_rules = {
--   {
--     intensity = "Normal",
--     font = wezterm.font({
--       family = "UbuntuMono Nerd Font",
--       weight = "Regular",
--       -- italic = true,
--     }),
--   },
-- }
config.keys = {
  -- paste from the clipboard
  -- { key = "V", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

  -- paste from the primary selection
  { key = "V", mods = "CTRL|SHIFT", action = act.PasteFrom("PrimarySelection") },
}
config.debug_key_events = true

config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

config.window_background_opacity = 0.85

config.cell_width = 0.9

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.front_end = "OpenGL"

return config
