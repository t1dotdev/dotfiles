#!/bin/bash

sketchybar --add event aerospace_workspace_change

sketchybar --add item space left \
  --subscribe space aerospace_workspace_change \
  --set space \
  background.color=0x33ffffff \
  icon.padding_left=8 \
  icon.padding_right=8 \
  script="$CONFIG_DIR/plugins/aerospace.sh"
