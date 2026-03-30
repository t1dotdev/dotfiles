local sbar   = require("sketchybar")
local colors = require("colors")

local calendar = sbar.add("item", "calendar", {
  position = "right",
  icon = {
    string        = "󰃰",
    font          = { family = "Symbols Nerd Font Mono", style = "Regular", size = 16.0 },
    color         = colors.white,
    padding_left  = 10,
    padding_right = 6,
  },
  label = {
    font          = { family = "Berkeley Mono", style = "Bold", size = 12.0 },
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
  padding_right = 6,
  update_freq   = 30,
})

calendar:subscribe({ "routine", "forced" }, function()
  calendar:set({ label = { string = os.date("%a %d %b  %H:%M") } })
end)

calendar:subscribe("mouse.clicked", function()
  sbar.exec("osascript -e 'tell application \"System Events\" to click menu bar item 1 of menu bar 1 of application process \"ControlCenter\"'")
end)
