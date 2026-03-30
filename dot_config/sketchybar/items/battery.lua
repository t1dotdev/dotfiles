local sbar   = require("sketchybar")
local colors = require("colors")

local battery = sbar.add("item", "battery", {
  position = "right",
  icon = {
    font          = { family = "SF Pro", style = "Bold", size = 15.0 },
    padding_left  = 10,
    padding_right = 4,
  },
  label = {
    font          = { family = "Berkeley Mono", style = "Regular", size = 11.0 },
    color         = colors.label_dim,
    padding_right = 10,
  },
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
  update_freq = 120,
})

local popup_font = { family = "Berkeley Mono", style = "Regular", size = 12.0 }
local popup_icon_font = { family = "Symbols Nerd Font Mono", style = "Regular", size = 16.0 }

local battery_cpu = sbar.add("item", "battery.cpu", {
  position = "popup.battery",
  icon = {
    string        = "󰻠",
    font          = popup_icon_font,
    color         = colors.white,
    padding_left  = 12,
    padding_right = 8,
  },
  label = {
    string        = "··· %",
    font          = popup_font,
    color         = colors.label_dim,
    padding_right = 12,
  },
  background    = { color = colors.transparent },
  padding_left  = 0,
  padding_right = 0,
  update_freq   = 3,
})

local battery_memory = sbar.add("item", "battery.memory", {
  position = "popup.battery",
  icon = {
    string        = "󰍛",
    font          = popup_icon_font,
    color         = colors.white,
    padding_left  = 12,
    padding_right = 8,
  },
  label = {
    string        = "··· %",
    font          = popup_font,
    color         = colors.label_dim,
    padding_right = 12,
  },
  background    = { color = colors.transparent },
  padding_left  = 0,
  padding_right = 0,
  update_freq   = 5,
})

battery:subscribe({ "routine", "power_source_change", "system_woke", "forced" }, function()
  sbar.exec("pmset -g batt", function(result)
    if not result then return end
    local pct = result:match("(%d+)%%")
    if not pct then return end
    local n = tonumber(pct)
    local charging = result:find("AC Power") ~= nil

    local icon
    if     charging  then icon = "􀢋"
    elseif n >= 90   then icon = "􀛨"
    elseif n >= 60   then icon = "􀺸"
    elseif n >= 30   then icon = "􀺶"
    elseif n >= 10   then icon = "􀛩"
    else                  icon = "􀛪"
    end

    battery:set({ icon = { string = icon }, label = { string = pct .. "%" } })
  end)
end)

battery:subscribe({ "mouse.exited.global", "front_app_switched" }, function()
  battery:set({ popup = { drawing = false } })
end)

battery:subscribe("mouse.clicked", function()
  battery:set({ popup = { drawing = "toggle" } })
end)

battery_cpu:subscribe("routine", function()
  sbar.exec("ps -A -o %cpu | awk '{s+=$1} END {printf \"%.0f\", s}'", function(cpu_raw)
    sbar.exec("sysctl -n hw.ncpu", function(cores_raw)
      local cpu   = tonumber(cpu_raw)   or 0
      local cores = tonumber(cores_raw) or 1
      battery_cpu:set({ label = { string = math.floor(cpu / cores) .. "%" } })
    end)
  end)
end)

battery_memory:subscribe("routine", function()
  sbar.exec("sysctl -n hw.memsize", function(total_raw)
    sbar.exec(
      "vm_stat | awk '/Pages active|Pages wired/ {gsub(/\\./, \"\", $NF); sum+=$NF} END {print sum}'",
      function(pages_raw)
        local total    = tonumber(total_raw)  or 0
        local pages    = tonumber(pages_raw)  or 0
        local total_gb = math.floor(total / 1073741824)
        local total_mb = math.floor(total / 1048576)
        local used_mb  = math.floor(pages * 4096 / 1048576)
        local avail_mb = total_mb - used_mb

        local used_s  = used_mb  >= 1024
                        and string.format("%.1fG", used_mb  / 1024)
                        or  (used_mb  .. "M")
        local avail_s = avail_mb >= 1024
                        and string.format("%.1fG", avail_mb / 1024)
                        or  (avail_mb .. "M")

        battery_memory:set({
          label = { string = used_s .. " / " .. total_gb .. "G  (" .. avail_s .. " free)" },
        })
      end
    )
  end)
end)
