#!/bin/bash

sketchybar --add item front_app left \
  --set front_app \
    background.color=0x00000000 \
    icon.font="sketchybar-app-font:Regular:14.0" \
    icon.color=$WHITE \
    icon.padding_left=6 \
    icon.padding_right=6 \
    label.font="Berkeley Mono:Bold:13.0" \
    label.color=$WHITE \
    script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
