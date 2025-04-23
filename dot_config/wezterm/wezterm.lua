-- Pull in the wezterm API
local wezterm = require("wezterm")
local colors = require("colors")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local config = wezterm.config_builder()

config.colors = {
	foreground = colors.fg,
	background = colors.bg,
	tab_bar = {
		background = colors.bg,
		active_tab = {
			bg_color = colors.primary,
			fg_color = colors.bg,
		},
		inactive_tab = {
			bg_color = colors.bg,
			fg_color = colors.fg,
		},
		new_tab = {
			bg_color = colors.bg,
			fg_color = colors.fg,
		},
	},
	cursor_bg = colors.fg,
	cursor_border = colors.fg,
	cursor_fg = colors.bg,
	selection_bg = colors.primary,
	selection_fg = colors.fg,
	ansi = {
		"#51576d", -- 0
		"#e78284", -- 1
		"#875fff", -- 2
		"#e5c890", -- 3
		"#8caaee", -- 4
		"#f4b8e4", -- 5
		"#81c8be", -- 6
		"#ffffff", -- 7
	},
	brights = {
		"#626880", -- 8
		"#e67172", -- 9
		"#875fff", -- 10
		"#d9ba73", -- 11
		"#7b9ef0", -- 12
		"#f2a4db", -- 13
		"#5abfb5", -- 14
		"#ffffff", -- 15
	},
}

config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	-- {
	-- 	key = "l",
	-- 	mods = "CTRL",
	-- 	action = wezterm.action.ActivatePaneDirection("Right"),
	-- },
	-- {
	-- 	key = "h",
	-- 	mods = "CTRL",
	-- 	action = wezterm.action.ActivatePaneDirection("Left"),
	-- },
	-- {
	-- 	key = "k",
	-- 	mods = "CTRL",
	-- 	action = wezterm.action.ActivatePaneDirection("Up"),
	-- },
	-- {
	-- 	key = "j",
	-- 	mods = "CTRL",
	-- 	action = wezterm.action.ActivatePaneDirection("Down"),
	-- },
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "K",
		mods = "CMD|SHIFT",
		action = wezterm.action.Multiple({
			wezterm.action.ClearScrollback("ScrollbackAndViewport"),
			wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},

	{
		key = "|",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "-",
		mods = "CMD",
		action = wezterm.action.SplitPane({
			direction = "Down",
		}),
	},
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.tab_index + 1
	title = wezterm.truncate_right(title, max_width - 2)
	return {
		{ Text = " " },
		{ Text = title },
		{ Text = " " },
	}
end)

config.window_padding = {
	top = 20,
	bottom = 0,
}

config.font = wezterm.font_with_fallback({
	{
		family = "JetBrainsMono NF",
		weight = "Bold",
	},
	{
		-- ภาษาไทย
		family = "Pridi",
		weight = "Regular",
	},
})

config.font_size = 15
config.line_height = 1

config.text_background_opacity = 0.9
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.use_fancy_tab_bar = false
config.window_decorations = "MACOS_FORCE_ENABLE_SHADOW|RESIZE"
config.hide_tab_bar_if_only_one_tab = false

-- you can put the rest of your Wezterm config here
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- if you want to use separate direction keys for move vs. resize, you
	-- can also do this:
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	},
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})

return config
