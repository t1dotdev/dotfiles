#!/bin/bash

sketchybar --add event aerospace_workspace_change

sketchybar --add item space left \
  --subscribe space aerospace_workspace_change \
  --set space \
  background.color=0x44ffffff \
  icon.padding_left=8 \
  icon.padding_right=8 \
  script="$CONFIG_DIR/plugins/aerospace.sh"

# SPACE_SIDS=(1 2 3 4 5)

# sketchybar --add event aerospace_workspace_change
# for sid in $(aerospace list-workspaces --all); do
# for sid in "${SPACE_SIDS[@]}"; do
#   sketchybar --add item space.$sid left \
#     --subscribe space.$sid aerospace_workspace_change \
#     --set space.$sid \
#     background.color=0x44ffffff \
#     icon=$sid \
#     label.font="sketchybar-app-font:Regular:13.0" \
#     label.padding_right=20 \
#     label.y_offset=-1 \
#     click_script="aerospace workspace $sid" \
#     script="$CONFIG_DIR/plugins/aerospace.sh $sid" # label="$sid" \
#
# done

#
# for sid in "${SPACE_SIDS[@]}"; do
#   sketchybar --add space space.$sid left \
#     --set space.$sid space=$sid \
#     icon=$sid \
#     label.font="sketchybar-app-font:Regular:13.0" \
#     label.padding_right=20 \
#     label.y_offset=-1 \
#     script="$PLUGIN_DIR/space.sh" \
#     click_script="yabai -m space --focus $sid"
#
# done
#
sketchybar --add item space_separator left \
  --set space_separator icon="􀆊" \
  icon.color=$WHITE icon.padding_left=4 \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/space_windows.sh" \
  --subscribe space_separator space_windows_change
