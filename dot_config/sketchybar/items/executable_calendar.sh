#!/bin/bash

sketchybar --add item calendar right \
  --set calendar \
    icon=󰃰 \
    icon.font="Symbols Nerd Font Mono:Regular:16.0" \
    icon.color=$WHITE \
    icon.padding_left=10 \
    icon.padding_right=6 \
    label.font="Berkeley Mono:Bold:12.0" \
    label.color=0xddffffff \
    label.padding_right=10 \
    background.color=0x18ffffff \
    background.corner_radius=8 \
    background.height=26 \
    background.drawing=on \
    padding_left=4 \
    padding_right=6 \
    update_freq=30 \
    script="$PLUGIN_DIR/clock.sh" \
    click_script="$PLUGIN_DIR/notification-center.sh"
