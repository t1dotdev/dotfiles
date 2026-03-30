local sbar   = require("sketchybar")
local colors = require("colors")

local popup_font      = { family = "Berkeley Mono", style = "Regular", size = 12.0 }
local popup_icon_font = { family = "SF Pro", style = "Bold", size = 14.0 }
local wifi = sbar.add("item", "wifi", {
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
  update_freq = 5,
})

local wifi_ssid = sbar.add("item", "wifi.ssid", {
  position = "popup.wifi",
  icon = {
    string        = "􀙇",
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

local wifi_ip = sbar.add("item", "wifi.ip", {
  position = "popup.wifi",
  icon = {
    string        = "􀆪",
    font          = popup_icon_font,
    color         = colors.white,
    padding_left  = 12,
    padding_right = 8,
  },
  label = {
    string        = "···",
    font          = popup_font,
    color         = colors.label_dim,
    padding_right = 12,
  },
  background    = { color = colors.transparent },
  padding_left  = 0,
  padding_right = 0,
})

local wifi_settings = sbar.add("item", "wifi.settings", {
  position = "popup.wifi",
  icon = {
    string        = "􀍟",
    font          = popup_icon_font,
    color         = colors.white,
    padding_left  = 12,
    padding_right = 8,
  },
  label = {
    string        = "Wi-Fi Settings...",
    font          = popup_font,
    color         = colors.link,
    padding_right = 12,
  },
  background    = { color = colors.transparent },
  padding_left  = 0,
  padding_right = 0,
})

local function apply_wifi(ip, ssid)
  if ip and ip ~= "" then
    wifi:set({ icon = { string = "􀙇" } })
    wifi_ssid:set({ label = { string = ssid or "Wi-Fi" }, icon = { string = "􀙇" } })
    wifi_ip:set({ label = { string = ip } })
  else
    wifi:set({ icon = { string = "􀙈" } })
    wifi_ssid:set({ label = { string = "Not Connected" }, icon = { string = "􀙈" } })
    wifi_ip:set({ label = { string = "No IP" } })
  end
end

wifi:subscribe({ "routine", "wifi_change", "system_woke", "forced" }, function()
  sbar.exec("ipconfig getifaddr en0 2>/dev/null", function(ip_raw)
    local ip = ip_raw and ip_raw:match("%S+")
    sbar.exec("networksetup -getairportnetwork en0 2>/dev/null", function(ssid_raw)
      local ssid = ssid_raw and ssid_raw:match("Current Wi%-Fi Network: (.+)")
      if not ssid or ssid == "" then
        sbar.exec(
          "ipconfig getsummary en0 2>/dev/null | awk -F' : ' '/^ *SSID/{print $2}'",
          function(ssid2_raw)
            local ssid2 = ssid2_raw and ssid2_raw:match("%S+")
            if ssid2 == "<redacted>" then ssid2 = nil end
            apply_wifi(ip, ssid2)
          end
        )
      else
        apply_wifi(ip, ssid)
      end
    end)
  end)
end)

wifi:subscribe({ "mouse.exited.global", "front_app_switched" }, function()
  wifi:set({ popup = { drawing = false } })
end)

wifi:subscribe("mouse.clicked", function()
  wifi:set({ popup = { drawing = "toggle" } })
end)

wifi_ip:subscribe("mouse.clicked", function()
  sbar.exec("ipconfig getifaddr en0 2>/dev/null | tr -d '\\n' | pbcopy")
  wifi:set({ popup = { drawing = false } })
end)

wifi_settings:subscribe("mouse.clicked", function()
  sbar.exec("open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi'")
  wifi:set({ popup = { drawing = false } })
end)
