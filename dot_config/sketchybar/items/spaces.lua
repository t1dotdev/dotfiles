local sbar   = require("sketchybar")
local colors = require("colors")
local icons  = require("icon_map")

local prev_focused = nil
local ws_icons     = {}
local ws_wids      = {}
local debounce     = false
sbar.add("event", "aerospace_workspace_change")

local spaces = {}
for sid = 1, 9 do
  spaces[sid] = sbar.add("item", "space." .. sid, {
    position = "left",
    icon = {
      string       = tostring(sid),
      font         = { family = "SF Pro", style = "Bold", size = 13.0 },
      color        = colors.white,
      padding_left = 14,
      padding_right = 4,
    },
    label = {
      font          = { family = "sketchybar-app-font", style = "Regular", size = 14.0 },
      color         = colors.white,
      padding_left  = 4,
      padding_right = 14,
    },
    background = {
      color         = colors.accent,
      corner_radius = 5,
      height        = 24,
      drawing       = false,
    },
    padding_left  = 3,
    padding_right = 3,
    drawing       = false,
  })

  spaces[sid]:subscribe("mouse.clicked", function()
    sbar.exec("aerospace workspace " .. sid)
  end)
end

local function swap_highlight(focused)
  if not focused or focused == prev_focused then return end

  local prev    = prev_focused
  prev_focused  = focused
  local prev_n  = tonumber(prev)
  local new_n   = tonumber(focused)
  if not new_n then return end

  if prev_n and spaces[prev_n] then
    if ws_icons[prev_n] and ws_icons[prev_n] ~= "" then
      spaces[prev_n]:set({
        icon       = { color = colors.white_dim },
        label      = { color = colors.white_dim },
        background = { drawing = false },
      })
    else
      spaces[prev_n]:set({ drawing = false })
    end
  end

  if spaces[new_n] then
    local has = ws_icons[new_n] and ws_icons[new_n] ~= ""
    if has then
      spaces[new_n]:set({
        drawing    = true,
        icon       = { string = focused, color = colors.white },
        label      = { color = colors.white },
        background = { drawing = true },
      })
    else
      spaces[new_n]:set({
        drawing    = true,
        icon       = { string = focused, color = colors.white },
        label      = { string = "" },
        background = { drawing = true },
      })
    end
  end
end

local function rebuild_icons(focused, move_dir)
  focused = focused or prev_focused
  if not focused then return end
  prev_focused = focused

  sbar.exec(
    "aerospace list-windows --all --format '%{workspace}|%{window-id}|%{app-name}'",
    function(result)
      if not result or result == "" then return end

      local ws_windows = {}
      local app_by_wid = {}
      for line in result:gmatch("[^\r\n]+") do
        local ws, wid, app = line:match("^(%S+)|(%S+)|(.+)$")
        if ws and wid then
          app = app:match("^%s*(.-)%s*$")
          local sid = tonumber(ws)
          if sid then
            ws_windows[sid] = ws_windows[sid] or {}
            table.insert(ws_windows[sid], wid)
            app_by_wid[wid] = app
          end
        end
      end

      local focused_n = tonumber(focused)

      for sid = 1, 9 do
        local wids = ws_windows[sid]

        if not wids or #wids == 0 then
          ws_icons[sid] = nil
          ws_wids[sid]  = nil
          if sid == focused_n then
            spaces[sid]:set({
              drawing    = true,
              icon       = { string = tostring(sid), color = colors.white },
              label      = { string = "" },
              background = { drawing = true },
            })
          else
            spaces[sid]:set({ drawing = false })
          end
        else
          local ordered  = {}
          local wid_set  = {}
          for _, w in ipairs(wids) do wid_set[w] = true end

          if ws_wids[sid] then
            for _, old in ipairs(ws_wids[sid]) do
              if wid_set[old] then
                table.insert(ordered, old)
              end
            end
          end
          for _, w in ipairs(wids) do
            local found = false
            for _, o in ipairs(ordered) do
              if o == w then found = true; break end
            end
            if not found then table.insert(ordered, w) end
          end

          if move_dir and sid == focused_n and #ordered > 1 then
            sbar.exec(
              "aerospace list-windows --focused --format '%{window-id}'",
              function(fw)
                local fwid = fw and fw:match("%S+")
                if not fwid then return end
                for i, w in ipairs(ordered) do
                  if w == fwid then
                    if (move_dir == "left" or move_dir == "up") and i > 1 then
                      ordered[i], ordered[i-1] = ordered[i-1], ordered[i]
                    elseif (move_dir == "right" or move_dir == "down") and i < #ordered then
                      ordered[i], ordered[i+1] = ordered[i+1], ordered[i]
                    end
                    break
                  end
                end
                ws_wids[sid] = ordered
              end
            )
          end

          ws_wids[sid] = ordered

          local icon_parts = {}
          for _, wid in ipairs(ordered) do
            local app = app_by_wid[wid]
            if app then table.insert(icon_parts, icons.get(app)) end
          end
          local icon_str = table.concat(icon_parts, " ")
          ws_icons[sid] = icon_str

          if sid == focused_n then
            spaces[sid]:set({
              drawing    = true,
              icon       = { string = tostring(sid), color = colors.white },
              label      = { string = icon_str, color = colors.white },
              background = { drawing = true },
            })
          else
            spaces[sid]:set({
              drawing    = true,
              icon       = { string = tostring(sid), color = colors.white_dim },
              label      = { string = icon_str, color = colors.white_dim },
              background = { drawing = false },
            })
          end
        end
      end
    end
  )
end

local controller = sbar.add("item", "space_controller", { drawing = false })

controller:subscribe("aerospace_workspace_change", function(env)
  local focused = env.FOCUSED_WORKSPACE
  local sort    = env.SORT_POSITIONS
  local mdir    = env.MOVE_DIR

  if sort or mdir then
    rebuild_icons(focused, mdir)
  else
    swap_highlight(focused)
  end

  debounce = true
  sbar.delay(0.15, function() debounce = false end)
end)

controller:subscribe("front_app_switched", function()
  if debounce then return end
  rebuild_icons(prev_focused)
end)

sbar.exec("aerospace list-workspaces --focused", function(result)
  local focused = result and result:match("%S+")
  if focused then
    prev_focused = focused
    rebuild_icons(focused)
  end
end)
