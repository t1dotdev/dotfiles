local wezterm = require("wezterm")
local colors = require("colors")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local config = wezterm.config_builder()

-- === Colors ===
config.colors = {
	foreground = colors.fg,
	background = colors.bg,
	cursor_bg = colors.fg,
	cursor_border = colors.fg,
	cursor_fg = colors.bg,
	selection_bg = colors.primary,
	selection_fg = colors.fg,
	tab_bar = {
		background = colors.bg,
		active_tab = { bg_color = colors.primary, fg_color = colors.bg },
		inactive_tab = { bg_color = colors.bg, fg_color = colors.fg },
		new_tab = { bg_color = colors.bg, fg_color = colors.fg },
	},
	ansi = {
		"#51576d",
		"#e78284",
		"#875fff",
		"#e5c890",
		"#8caaee",
		"#f4b8e4",
		"#81c8be",
		"#ffffff",
	},
	brights = {
		"#626880",
		"#e67172",
		"#875fff",
		"#d9ba73",
		"#7b9ef0",
		"#f2a4db",
		"#5abfb5",
		"#ffffff",
	},
}

-- === Font ===
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono NF", weight = "Bold" },
	{ family = "Pridi", weight = "Regular" },
})
config.font_size = 15
config.line_height = 1

-- === Window ===
config.window_padding = { top = 20, bottom = 0 }
config.text_background_opacity = 0.9
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations = "MACOS_FORCE_ENABLE_SHADOW|RESIZE"

-- === Keybindings ===
config.keys = {
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
	{
		key = "K",
		mods = "CMD|SHIFT",
		action = wezterm.action.Multiple({
			wezterm.action.ClearScrollback("ScrollbackAndViewport"),
			wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
	{ key = "d", mods = "CMD", action = wezterm.action.SplitPane({ direction = "Right" }) },
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitPane({ direction = "Down" }) },
}

-- === Tab Title ===
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local title = wezterm.truncate_right(tab.tab_index + 1, max_width - 2)
	return { { Text = " " .. title .. " " } }
end)

-- === Right Status Bar ===
-- wezterm.on("update-right-status", function(window, pane)
-- 	local cells = {}
-- 	-- table.insert(cells, wezterm.nerdfonts.md_apple)
--
-- 	local cwd_uri = pane:get_current_working_dir()
-- 	if cwd_uri then
-- 		local cwd, hostname = "", ""
-- 		if type(cwd_uri) == "userdata" then
-- 			cwd = cwd_uri.file_path
-- 			hostname = cwd_uri.host or wezterm.hostname()
-- 		else
-- 			cwd_uri = cwd_uri:sub(8)
-- 			local slash = cwd_uri:find("/")
-- 			if slash then
-- 				hostname = cwd_uri:sub(1, slash - 1)
-- 				cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
-- 					return string.char(tonumber(hex, 16))
-- 				end)
-- 			end
-- 		end
-- 		local dot = hostname:find("[.]")
-- 		if dot then
-- 			hostname = hostname:sub(1, dot - 1)
-- 		end
-- 		if hostname == "" then
-- 			hostname = wezterm.hostname()
-- 		end
-- 		table.insert(cells, cwd)
-- 	end
--
-- 	local handle = io.popen("ipconfig getifaddr en0 || ipconfig getifaddr en1")
-- 	local local_ip = handle:read("*a"):gsub("\n", "")
-- 	handle:close()
-- 	-- table.insert(cells, wezterm.nerdfonts.cod_globe .. " " .. local_ip)
--
-- 	for _, b in ipairs(wezterm.battery_info()) do
-- 		local icons = {
-- 			wezterm.nerdfonts.md_battery_10,
-- 			wezterm.nerdfonts.md_battery_20,
-- 			wezterm.nerdfonts.md_battery_30,
-- 			wezterm.nerdfonts.md_battery_40,
-- 			wezterm.nerdfonts.md_battery_50,
-- 			wezterm.nerdfonts.md_battery_60,
-- 			wezterm.nerdfonts.md_battery_70,
-- 			wezterm.nerdfonts.md_battery_80,
-- 			wezterm.nerdfonts.md_battery_90,
-- 			wezterm.nerdfonts.md_battery,
-- 			wezterm.nerdfonts.md_battery_charging,
-- 		}
-- 		local level = math.floor(b.state_of_charge * 10)
-- 		local icon = b.state == "Charging" and icons[11] or icons[level]
-- 		if b.state ~= "Empty" then
-- 			table.insert(cells, icon .. " " .. string.format("%.0f%%", b.state_of_charge * 100))
-- 		end
-- 	end
--
-- 	local text_fg, bg = "#121212", colors.primary
-- 	local elements, count = {}, 0
-- 	local function push(text, is_last)
-- 		count = count + 1
-- 		table.insert(elements, { Foreground = { Color = text_fg } })
-- 		table.insert(elements, { Background = { Color = bg } })
-- 		table.insert(elements, { Text = " " .. text .. " " })
-- 	end
--
-- 	while #cells > 0 do
-- 		push(table.remove(cells, 1), #cells == 0)
-- 	end
--
-- 	window:set_right_status(wezterm.format(elements))
-- end)

-- === Smart Splits ===
smart_splits.apply_to_config(config, {
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	},
	modifiers = {
		move = "CTRL",
		resize = "META",
	},
	log_level = "info",
})

return config
