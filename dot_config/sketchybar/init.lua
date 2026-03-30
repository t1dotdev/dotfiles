local home = os.getenv("USER")
local config = "/Users/" .. home .. "/.config/sketchybar"

package.cpath = package.cpath .. ";" .. "/Users/" .. home .. "/.local/share/sketchybar_lua/?.so"
package.path  = package.path  .. ";" .. config .. "/?.lua" .. ";" .. config .. "/?/init.lua"

local sbar   = require("sketchybar")
local colors = require("colors")

sbar.begin_config()

sbar.bar({
  height        = 36,
  blur_radius   = 20,
  position      = "top",
  sticky        = false,
  padding_left  = 8,
  padding_right = 8,
  color         = colors.bar,
})

sbar.default({
  icon = {
    font          = { family = "SF Pro", style = "Bold", size = 14.0 },
    color         = colors.white,
    padding_left  = 4,
    padding_right = 4,
  },
  label = {
    font          = { family = "Berkeley Mono", style = "Regular", size = 13.0 },
    color         = colors.white,
    padding_left  = 0,
    padding_right = 0,
  },
  background = {
    color         = colors.item_bg,
    corner_radius = 4,
    height        = 24,
  },
  padding_left  = 6,
  padding_right = 6,
})

sbar.add("item", "front_logo", {
  position = "left",
  icon = {
    string        = "󰬁󰬺",
    font          = { family = "Symbols Nerd Font Mono", style = "Regular", size = 12.0 },
    color         = colors.white,
    padding_left  = 8,
    padding_right = 8,
  },
  label      = { drawing = false },
  background = { drawing = false },
})

require("items.spaces")

sbar.add("item", "space_separator", {
  position = "left",
  icon = {
    string       = "􀆊",
    color        = colors.white,
    padding_left = 4,
  },
  label      = { drawing = false },
  background = { drawing = false },
})

require("items.front_app")

require("items.calendar")
require("items.battery")
require("items.wifi")
require("items.volume")
require("items.keyboard")

sbar.end_config()
sbar.event_loop()
