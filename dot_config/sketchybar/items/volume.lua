local sbar   = require("sketchybar")
local colors = require("colors")

local popup_font      = { family = "Berkeley Mono", style = "Regular", size = 12.0 }
local popup_icon_font = { family = "SF Pro", style = "Bold", size = 14.0 }

local volume = sbar.add("item", "volume", {
  position = "right",
  icon = {
    font          = { family = "SF Pro", style = "Bold", size = 15.0 },
    color         = colors.white,
    padding_left  = 10,
    padding_right = 10,
  },
  label = { drawing = false },
  background = {
    color         = colors.pill_bg,
    corner_radius = 8,
    height        = 26,
    drawing       = true,
  },
  padding_left  = 4,
  padding_right = 4,
  popup = {
    align      = "right",
    background = {
      color         = colors.popup_bg,
      corner_radius = 8,
      border_color  = colors.popup_border,
      border_width  = 1,
    },
    blur_radius = 20,
  },
  update_freq = 10,
})

local vol_device = sbar.add("item", "volume.device", {
  position = "popup.volume",
  icon = {
    string        = "􀊩",
    font          = popup_icon_font,
    color         = colors.white,
    padding_left  = 12,
    padding_right = 8,
  },
  label = {
    string        = "Loading...",
    font          = popup_font,
    color         = colors.label_dim,
    padding_right = 12,
  },
  background    = { color = colors.transparent },
  padding_left  = 0,
  padding_right = 0,
})

local vol_slider = sbar.add("slider", "volume.slider", 170, {
  position = "popup.volume",
  slider = {
    highlight_color = colors.white,
    background = {
      color         = 0x40ffffff,
      height        = 6,
      corner_radius = 3,
    },
  },
  padding_left  = 8,
  padding_right = 8,
})

local vol_settings = sbar.add("item", "volume.settings", {
  position = "popup.volume",
  icon = {
    string        = "􀍟",
    font          = popup_icon_font,
    color         = colors.white,
    padding_left  = 12,
    padding_right = 8,
  },
  label = {
    string        = "Sound Settings...",
    font          = popup_font,
    color         = colors.link,
    padding_right = 12,
  },
  background    = { color = colors.transparent },
  padding_left  = 0,
  padding_right = 0,
})

local vol_bluetooth = sbar.add("item", "volume.bluetooth", {
  position = "popup.volume",
  icon = {
    string        = "󰂯",
    font          = { family = "Symbols Nerd Font Mono", style = "Regular", size = 14.0 },
    color         = colors.white,
    padding_left  = 12,
    padding_right = 8,
  },
  label = {
    string        = "Bluetooth Settings...",
    font          = popup_font,
    color         = colors.link,
    padding_right = 12,
  },
  background    = { color = colors.transparent },
  padding_left  = 0,
  padding_right = 0,
})

local function pick_icon(vol, muted, device)
  if device and device:lower():find("airpod") then return "􀪷" end
  if muted or vol == 0 then return "􀊣" end
  if vol >= 70 then return "􀊩" end
  if vol >= 30 then return "􀊧" end
  return "􀊥"
end

local function refresh_volume(vol_override)
  sbar.exec(
    "osascript -e 'set vs to get volume settings' -e 'return (output volume of vs) & \"|\" & (output muted of vs)'",
    function(result)
      if not result then return end
      local vol_s, muted_s = result:match("(%d+)|(%w+)")
      local vol   = vol_override or tonumber(vol_s) or 0
      local muted = muted_s == "true"

      local dev_cmd = "SwitchAudioSource -c 2>/dev/null || "
        .. "system_profiler SPAudioDataType 2>/dev/null | "
        .. "awk '/:$/ { gsub(/^[ \\t]+|[ \\t]*:$/, \"\", $0); name=$0 } "
        .. "/Default Output Device: Yes/ { print name; exit }'"
      sbar.exec(dev_cmd, function(dev_raw)
        local device = dev_raw and dev_raw:match("[^\n]+") or "Built-in Output"
        local icon   = pick_icon(vol, muted, device)

        local vol_label = muted and "Muted" or (vol .. "%")

        volume:set({ icon = { string = icon } })
        vol_device:set({
          icon  = { string = icon },
          label = { string = device .. " · " .. vol_label },
        })
        vol_slider:set({ slider = { percentage = vol } })
      end)
    end
  )
end

volume:subscribe({ "routine", "system_woke", "forced" }, function()
  refresh_volume()
end)

volume:subscribe("volume_change", function(env)
  local vol = tonumber(env.INFO)
  refresh_volume(vol)
end)

volume:subscribe({ "mouse.exited.global", "front_app_switched" }, function()
  volume:set({ popup = { drawing = false } })
end)

volume:subscribe("mouse.clicked", function()
  volume:set({ popup = { drawing = "toggle" } })
end)

vol_slider:subscribe("mouse.clicked", function(env)
  local info = vol_slider:query()
  local pct  = info and info.slider and info.slider.percentage
  if pct then
    sbar.exec("osascript -e 'set volume output volume " .. math.floor(pct) .. "'")
  end
end)

vol_settings:subscribe("mouse.clicked", function()
  sbar.exec("open 'x-apple.systempreferences:com.apple.preference.sound'")
  volume:set({ popup = { drawing = false } })
end)

vol_bluetooth:subscribe("mouse.clicked", function()
  sbar.exec("open /System/Library/PreferencePanes/Bluetooth.prefPane")
  volume:set({ popup = { drawing = false } })
end)
