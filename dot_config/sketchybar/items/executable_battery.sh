#!/bin/bash

sketchybar --add item battery right \
  --set battery \
    icon.font="SF Pro:Bold:15.0" \
    icon.padding_left=10 \
    icon.padding_right=4 \
    label.font="SF Pro:Medium:11.0" \
    label.color=0xccffffff \
    label.padding_right=10 \
    background.color=0x18ffffff \
    background.corner_radius=8 \
    background.height=26 \
    background.drawing=on \
    padding_left=4 \
    padding_right=4 \
    popup.align=right \
    popup.background.color=0xE616161e \
    popup.background.corner_radius=8 \
    popup.background.border_color=0x33ffffff \
    popup.background.border_width=1 \
    popup.blur_radius=20 \
    update_freq=120 \
    script="$PLUGIN_DIR/battery.sh" \
    click_script="sketchybar --set battery popup.drawing=toggle" \
  --subscribe battery system_woke power_source_change mouse.exited.global front_app_switched \
  \
  --add item battery.cpu popup.battery \
  --set battery.cpu \
    icon=󰻠 \
    icon.font="Symbols Nerd Font Mono:Regular:16.0" \
    icon.color=$WHITE \
    icon.padding_left=12 \
    icon.padding_right=8 \
    label="··· %" \
    label.font="SF Pro:Medium:12.0" \
    label.color=0xccffffff \
    label.padding_right=12 \
    background.color=0x00000000 \
    padding_left=0 \
    padding_right=0 \
    update_freq=3 \
    script="$PLUGIN_DIR/cpu.sh" \
  \
  --add item battery.memory popup.battery \
  --set battery.memory \
    icon=󰍛 \
    icon.font="Symbols Nerd Font Mono:Regular:16.0" \
    icon.color=$WHITE \
    icon.padding_left=12 \
    icon.padding_right=8 \
    label="··· %" \
    label.font="SF Pro:Medium:12.0" \
    label.color=0xccffffff \
    label.padding_right=12 \
    background.color=0x00000000 \
    padding_left=0 \
    padding_right=0 \
    update_freq=5 \
    script="$PLUGIN_DIR/memory.sh"
