local sbar   = require("sketchybar")
local colors = require("colors")

local CONFIG_DIR = os.getenv("HOME") .. "/.config/sketchybar"

local layout_map = {
  ["ABC"]  = "EN",
  ["Thai"] = "TH",
}

local keyboard = sbar.add("item", "keyboard", {
  position = "right",
  icon = {
    string        = "󰌌",
    font          = { family = "Symbols Nerd Font Mono", style = "Regular", size = 14.0 },
    color         = colors.white,
    padding_left  = 10,
    padding_right = 4,
  },
  label = {
    font          = { family = "Berkeley Mono", style = "Bold", size = 11.0 },
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
})

sbar.add("event", "keyboard_change", "AppleSelectedInputSourcesChangedNotification")

local function update_layout()
  sbar.exec(
    "defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources"
    .. " | grep 'KeyboardLayout Name' | head -1"
    .. " | sed 's/.*= \"\\{0,1\\}\\([^\"]*\\)\"\\{0,1\\};/\\1/'",
    function(result)
      local layout = result and result:match("%S+")
      if not layout then return end
      keyboard:set({ label = { string = layout_map[layout] or layout } })
    end
  )
end

keyboard:subscribe({ "keyboard_change", "forced" }, function()
  update_layout()
end)

keyboard:subscribe("mouse.clicked", function()
  local bin = CONFIG_DIR .. "/plugins/keyboard_switch"
  sbar.exec(bin)
end)
