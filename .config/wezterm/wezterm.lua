local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback {
  "IosevkaTerm Nerd Font",
  "Noto Color Emoji",
}
config.font_size = 10
config.enable_wayland = false
config.default_prog = { "/bin/fish" }
config.enable_tab_bar = false
config.force_reverse_video_cursor = true
config.window_background_opacity = 0.9
config.adjust_window_size_when_changing_font_size = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local one_dark = wezterm.color.get_builtin_schemes()['OneDark (Gogh)']
one_dark.foreground = "#ADADD4"
one_dark.background = "#2C2D30"
config.color_schemes = {
  ['My OneDark'] = one_dark,
}
config.color_scheme = 'My OneDark'

return config
