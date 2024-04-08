-- Pull in the wezterm API
local wezterm = require("wezterm")
local colors = require("colors")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

wezterm.on("gui-startup", function(cmd)
	local screenInfo = wezterm.gui.screens()

	-- local padSize = 0
	local screenWidth = screenInfo["virtual_width"]
	local screenHeight = screenInfo["virtual_height"]

	local tab, pane, window = wezterm.mux.spawn_window(cmd or {
		workspace = "main",
	})
	if window ~= nil then
		window:gui_window():set_position(screenWidth / 4, screenHeight / 4)
	end
end)

local function get_local_ip()
	local handle = io.popen("ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}'")
	local local_ip = handle:read("*a")
	handle:close()
	return local_ip
end

wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	-- Figure out the cwd and host of the current pane.
	-- This will pick up the hostname for the remote host if your
	-- shell is using OSC 7 on the remote host.
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		local cwd = ""
		local hostname = ""

		if type(cwd_uri) == "userdata" then
			-- Running on a newer version of wezterm and we have
			-- a URL object here, making this simple!

			cwd = cwd_uri.file_path
			hostname = cwd_uri.host or wezterm.hostname()
		else
			-- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
			-- which doesn't have the Url object
			cwd_uri = cwd_uri:sub(8)
			local slash = cwd_uri:find("/")
			if slash then
				hostname = cwd_uri:sub(1, slash - 1)
				-- and extract the cwd from the uri, decoding %-encoding
				cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
					return string.char(tonumber(hex, 16))
				end)
			end
		end
		-- Remove the domain name portion of the hostname
		local dot = hostname:find("[.]")
		if dot then
			hostname = hostname:sub(1, dot - 1)
		end
		if hostname == "" then
			hostname = wezterm.hostname()
		end

		table.insert(cells, cwd)
		-- table.insert(cells, hostname)
	end
	local handle = io.popen("ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}'")
	local local_ip = handle:read("*a")
	handle:close()
	-- Remove the newline character from the end
	local_ip = string.gsub(local_ip, "\n", "")
	table.insert(cells, string.format(wezterm.nerdfonts.cod_globe .. " " .. local_ip))
	-- I like my date/time in this style: "Wed Mar 3 08:14"
	-- local date = wezterm.strftime("%a %-d %b %H:%M")
	-- table.insert(cells, date)

	-- An entry for each battery (typically 0 or 1 battery)
	for _, b in ipairs(wezterm.battery_info()) do
		local battery_icons = {
			wezterm.nerdfonts.md_battery_10,
			wezterm.nerdfonts.md_battery_20,
			wezterm.nerdfonts.md_battery_30,
			wezterm.nerdfonts.md_battery_40,
			wezterm.nerdfonts.md_battery_50,
			wezterm.nerdfonts.md_battery_60,
			wezterm.nerdfonts.md_battery_70,
			wezterm.nerdfonts.md_battery_80,
			wezterm.nerdfonts.md_battery_90,
			wezterm.nerdfonts.md_battery,
			wezterm.nerdfonts.md_battery_charging,
		}
		-- table.insert(cells, battery_icons[b.state_of_charge * 5 + 1])
		-- table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
		local battery = (b.state_of_charge * 100) // 10
		local isCharging = b.state == "Charging"
		if isCharging then
			battery = 11
		end
		-- table.insert(cells, string.format(battery_icons[battery]))
		table.insert(cells, string.format(battery_icons[battery] .. " " .. "%.0f%%", b.state_of_charge * 100))
	end

	-- The powerline < symbol
	local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	local colors = {
		"#7D7CF9",
		"#A86AEF",
		"#B465EC",
		"#BB62EA",
		"#CB5BE6",
	}

	-- Foreground color for the text across the fade
	local text_fg = "#111111"

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	function push(text, is_last)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

config.colors = {
	foreground = "#c7c7c7",
	background = colors.bg,
	tab_bar = {
		background = colors.bg,
		active_tab = {
			bg_color = colors.primary,
			fg_color = colors.bg,
		},
		inactive_tab = {
			bg_color = colors.bg,
			fg_color = "#c7c7c7",
		},
		new_tab = {
			bg_color = colors.bg,
			fg_color = "#c7c7c7",
		},
	},
	cursor_bg = "#D8DEE9",
	cursor_border = "#D8DEE9",
	cursor_fg = "#2E3440",
	selection_bg = "#4C566A",
	selection_fg = "#D8DEE9",
	ansi = { "#3e4452", "#f3475d", "#7cc457", "#dc8b44", "#00a8f7", "#cf5be5", "#00b6c5", "#e6e6e6" },
	brights = { "#4d5668", "#ff5169", "#93e265", "#fda04d", "#00c7ff", "#ee6bff", "#00d4e3", "#d6dae1" },
}
config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
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
config.window_close_confirmation = "NeverPrompt"
config.initial_cols = 100
config.initial_rows = 25

config.window_padding = {
	-- left = 10,
	-- right = 0,
	-- top = 0,
	bottom = 0,
}

config.text_background_opacity = 0.8
config.macos_window_background_blur = 20
config.window_background_opacity = 0.8
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
-- config.integrated_title_button_style = "Gnome"
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.hide_tab_bar_if_only_one_tab = false
-- config.tab_bar_style = {
-- 	window_hide = wezterm.format({
-- 		{ Foreground = { Color = colors.success } },
-- 		{ Background = { Color = colors.bg } },
-- 		{ Text = " " .. wezterm.nerdfonts.md_circle_small .. " " },
-- 	}),
-- 	window_hide_hover = wezterm.format({
-- 		{ Foreground = { Color = colors.success } },
-- 		{ Background = { Color = colors.bg } },
-- 		{ Text = " " .. wezterm.nerdfonts.md_checkbox_blank_circle_outline .. " " },
-- 	}),
-- 	window_maximize = wezterm.format({
-- 		{ Foreground = { Color = colors.warning } },
-- 		{ Background = { Color = colors.bg } },
-- 		{ Text = " " .. wezterm.nerdfonts.md_circle_small .. " " },
-- 	}),
-- 	window_maximize_hover = wezterm.format({
-- 		{ Foreground = { Color = colors.warning } },
-- 		{ Background = { Color = colors.bg } },
-- 		{ Text = " " .. wezterm.nerdfonts.md_checkbox_blank_circle_outline .. " " },
-- 	}),
-- 	window_close = wezterm.format({
-- 		{ Foreground = { Color = colors.danger } },
-- 		{ Background = { Color = colors.bg } },
-- 		{ Text = " " .. wezterm.nerdfonts.md_circle_small .. " " },
-- 	}),
-- 	window_close_hover = wezterm.format({
-- 		{ Foreground = { Color = colors.danger } },
-- 		{ Background = { Color = colors.bg } },
-- 		{ Text = " " .. wezterm.nerdfonts.md_checkbox_blank_circle_outline .. " " },
-- 	}),
-- }
-- config.window_frame = {
-- 	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
-- 	font_size = 12.0,
-- 	active_titlebar_bg = "rgb(17,17,17,0.85)",
-- }
return config
