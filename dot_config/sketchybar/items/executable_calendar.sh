#!/bin/bash

# cc = $(osascript -e 'tell application "System Events" to click menu bar item 1 of menu bar 1 of application process "ControlCenter"')

sketchybar --add item calendar right \
  --set calendar icon=􀧞 \
  update_freq=1 script="$PLUGIN_DIR/calendar.sh" \
  --set calendar click_script="$PLUGIN_DIR/control-center.sh"
