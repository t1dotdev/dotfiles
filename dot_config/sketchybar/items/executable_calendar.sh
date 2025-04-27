#!/usr/bin/env bash

sketchybar --add item calendar right \
  --set calendar \
  icon=􀧞 \
  update_freq=60 \
  script="$PLUGIN_DIR/calendar.sh" \
  click_script="$PLUGIN_DIR/notification-center.sh"
