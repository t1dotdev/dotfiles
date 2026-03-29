#!/bin/bash

sketchybar --add event aerospace_workspace_change

for sid in $(seq 1 9); do
  sketchybar --add item space.$sid left \
    --set space.$sid \
      icon="$sid" \
      icon.font="SF Pro:Bold:13.0" \
      icon.color=$WHITE \
      icon.padding_left=8 \
      icon.padding_right=4 \
      label.font="sketchybar-app-font:Regular:14.0" \
      label.color=$WHITE \
      label.padding_left=4 \
      label.padding_right=8 \
      background.color=$ACCENT_COLOR \
      background.corner_radius=5 \
      background.height=24 \
      background.drawing=off \
      padding_left=3 \
      padding_right=3 \
      drawing=off \
      click_script="aerospace workspace $sid"
done

sketchybar --add item space_controller left \
  --subscribe space_controller aerospace_workspace_change front_app_switched \
  --set space_controller \
    drawing=off \
    script="$CONFIG_DIR/plugins/aerospace.sh"
