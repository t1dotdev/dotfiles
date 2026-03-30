local sbar   = require("sketchybar")
local colors = require("colors")
local icons  = require("icon_map")

local front_app = sbar.add("item", "front_app", {
  position = "left",
  background = { color = colors.transparent },
  icon = {
    font          = { family = "sketchybar-app-font", style = "Regular", size = 14.0 },
    color         = colors.white,
    padding_left  = 6,
    padding_right = 6,
  },
  label = {
    font          = { family = "Berkeley Mono", style = "Bold", size = 13.0 },
    color         = colors.white,
  },
})

front_app:subscribe("front_app_switched", function(env)
  local app = env.INFO
  front_app:set({
    label = { string = app },
    icon  = { string = icons.get(app) },
  })
end)
