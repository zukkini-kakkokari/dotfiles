-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.font_size = 25
config.font = wezterm.font 'Iosevka Nerd Font Mono'

config.font_rules = {
  {
    italic = false,
    intensity = "Half",
    font = wezterm.font({
      family = "Iosevka Nerd Font Mono",
      weight = "Regular",
    })
  },  
  {
    italic = true,
    intensity = "Half",
    font = wezterm.font({
      family = "Iosevka Nerd Font Mono",
      weight = "Regular",
    })
  }
}

config.adjust_window_size_when_changing_font_size = false
config.enable_tab_bar = false
config.exit_behavior = 'Close'



local act = wezterm.action

config.keys = {
  -- { key = 'u', mods = 'CTRL', action = act.ScrollByPage(-0.5) },
  -- { key = 'd', mods = 'CTRL', action = act.ScrollByPage(0.5) },
  { key = 'k', mods = 'CTRL', action = act.ScrollByLine(-5) },
  { key = 'j', mods = 'CTRL', action = act.ScrollByLine(5) },

}


-- and finally, return the configuration to wezterm
return config
