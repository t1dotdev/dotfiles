#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh
#
#
# apps=$(aerospace list-windows --workspace $(aerospace list-workspaces --focused) --format '%{app-name}')
# icon_strip=" "
# if [ "${apps}" != "" ]; then
#   while read -r app; do
#     icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
#   done <<<"${apps}"
# else
#   icon_strip=" —"
# fi
# sketchybar --set space.$space label="$icon_strip"

sketchybar --set $NAME \
  icon=$(aerospace list-workspaces --focused) \ 
label="$icon_strip" \
  label.y_offset=-1 \
  label.padding_right=20 \
  label.font="sketchybar-app-font:Regular:13.0"

# if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
#   sketchybar --set $NAME background.drawing=on
# else
#   sketchybar --set $NAME background.drawing=off
# fi
