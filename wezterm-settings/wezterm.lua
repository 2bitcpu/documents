local wezterm = require 'wezterm';
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ime
config.use_ime = true

-- font
config.font = wezterm.font_with_fallback({
  { family = "Cica", weight = 'Bold' },
  { family = "Cica", assume_emoji_presentation = true, weight = 'Bold' },
})
config.font_size = 13
config.adjust_window_size_when_changing_font_size = false

-- action
config.mouse_bindings = {
--  選択したテキストをコピー
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CopyTo 'ClipboardAndPrimarySelection',
  },
-- 右クリックでペースト 
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
}

-- window
config.initial_cols = 128
config.initial_rows = 32
-- タブバーをタブがひとつの時は表示しない
config.hide_tab_bar_if_only_one_tab = true

-- color scheme
config.color_scheme = "Dracula+"
config.char_select_bg_color = "#282A36"
config.char_select_fg_color = "#F8F8F2"

config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

-- bell
config.audible_bell = "Disabled"

-- keybinds
-- デフォルトのkeybindを無効化
config.disable_default_key_bindings = true
-- `keybinds.lua`を読み込み
local keybind = require 'keybinds'
-- keybindの設定
config.keys = keybind.keys
config.key_tables = keybind.key_tables

-- exit
config.exit_behavior = 'CloseOnCleanExit'

return config
