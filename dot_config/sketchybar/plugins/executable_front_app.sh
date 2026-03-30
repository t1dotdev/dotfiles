#!/bin/bash

if [ "$SENDER" = "front_app_switched" ]; then
  . "$CONFIG_DIR/plugins/icon_map_fn.sh" > /dev/null 2>&1
  icon_map "$INFO"
  sketchybar --set $NAME label="$INFO" icon="$icon_result"
fi
