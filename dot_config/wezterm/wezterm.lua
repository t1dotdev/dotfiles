local wezterm = require("wezterm")
local colors = require("colors")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local config = wezterm.config_builder()

-- === Colors ===
config.colors = {
	foreground = colors.fg,
	background = colors.bg,
	cursor_bg = "#f5e0dc",
	cursor_border = "#f5e0dc",
	cursor_fg = colors.bg,
	selection_bg = "#353749",
	selection_fg = "#cdd6f4",
	tab_bar = {
		background = colors.bg,
		active_tab = { bg_color = colors.primary, fg_color = colors.bg },
		inactive_tab = { bg_color = colors.bg, fg_color = colors.fg },
		new_tab = { bg_color = colors.bg, fg_color = colors.fg },
	},
	ansi = {
		"#45475a",
		"#f38ba8",
		"#a6e3a1",
		"#f9e2af",
		"#89b4fa",
		"#875fff",
		"#94e2d5",
		"#a6adc8",
	},
	brights = {
		"#585b70",
		"#f38ba8",
		"#a6e3a1",
		"#f9e2af",
		"#89b4fa",
		"#875fff",
		"#94e2d5",
		"#bac2de",
	},
}

-- === Font ===
config.font = wezterm.font_with_fallback({
	{ family = "Berkeley Mono", weight = "Bold" },
	{ family = "JetBrains Mono", weight = "Bold" },
	{ family = "Courier MonoThai", weight = "Bold" },
})
config.font_size = 16
config.line_height = 1

-- === Window ===
config.window_padding = { top = 20, bottom = 0 }
config.text_background_opacity = 0.93
config.window_background_opacity = 0.93
config.macos_window_background_blur = 25
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.window_decorations = "MACOS_FORCE_ENABLE_SHADOW|RESIZE"

-- === Keybindings ===
config.keys = {
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	-- Cmd+Q: confirm, then quit GUI only. Mux server + sessions survive, reattach on relaunch.
	{
		key = "q",
		mods = "CMD",
		action = wezterm.action.InputSelector({
			title = "Quit WezTerm? (sessions kept)",
			choices = {
				{ id = "quit", label = "Quit (keep mux + sessions)" },
				{ id = "cancel", label = "Cancel" },
			},
			action = wezterm.action_callback(function(window, pane, id, _)
				if id ~= "quit" then
					return
				end
				window:perform_action(wezterm.action.QuitApplication, pane)
			end),
		}),
	},
	-- Cmd+Shift+K: confirm, then kill the persistent mux server (clear all sessions), then quit
	{
		key = "K",
		mods = "CMD|SHIFT",
		action = wezterm.action.InputSelector({
			title = "Kill everything? (all sessions lost)",
			choices = {
				{ id = "kill", label = "Kill mux + all sessions, then quit" },
				{ id = "cancel", label = "Cancel" },
			},
			action = wezterm.action_callback(function(window, pane, id, _)
				if id ~= "kill" then
					return
				end
				os.execute("ps -axo pid,comm | awk '/wezterm-mux-server/{print $1}' | xargs kill 2>/dev/null")
				window:perform_action(wezterm.action.QuitApplication, pane)
			end),
		}),
	},
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
	{
		key = "x",
		mods = "CMD|SHIFT",
		action = wezterm.action.Multiple({
			wezterm.action.ClearScrollback("ScrollbackAndViewport"),
			wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
	{ key = "d", mods = "CMD", action = wezterm.action.SplitPane({ direction = "Right" }) },
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitPane({ direction = "Down" }) },
	-- Word jump: Cmd+Left/Right -> Alt+b / Alt+f (readline word motion)
	{ key = "LeftArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "b", mods = "ALT" }) },
	{ key = "RightArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "f", mods = "ALT" }) },
	-- Multiplexing: detach from mux server (jobs keep running)
	{ key = "u", mods = "CMD|SHIFT", action = wezterm.action.DetachDomain({ DomainName = "unix" }) },
	-- Workspaces (named sessions)
	{ key = "p", mods = "CMD|SHIFT", action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	{ key = "]", mods = "CMD|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(1) },
	{ key = "[", mods = "CMD|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(-1) },
	{
		key = "n",
		mods = "CMD|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { Color = colors.primary } },
				{ Text = "New workspace name:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line and line ~= "" then
					window:perform_action(wezterm.action.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
}

-- === Tab Title ===
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local title = wezterm.truncate_right(tab.tab_index + 1, max_width - 2)
	return { { Text = " " .. title .. " " } }
end)

-- === Active Workspace in status bar ===
wezterm.on("update-right-status", function(window, _)
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = colors.primary } },
		{ Text = " " .. window:active_workspace() .. " " },
	}))
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

-- === Multiplexing ===
-- Local unix-domain mux server. Tabs/panes survive GUI quit + relaunch.
config.unix_domains = {
	{ name = "unix" },
}
-- Auto-attach to the unix mux on startup, so every window is persistent.
config.default_gui_startup_args = { "connect", "unix" }

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
