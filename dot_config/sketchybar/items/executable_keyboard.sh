#!/bin/bash

sketchybar --add item keyboard right \
  --set keyboard \
    icon=󰌌 \
    icon.font="Symbols Nerd Font Mono:Regular:14.0" \
    icon.color=$WHITE \
    icon.padding_left=10 \
    icon.padding_right=4 \
    label.font="SF Pro:Bold:11.0" \
    label.color=0xccffffff \
    label.padding_right=10 \
    background.color=0x18ffffff \
    background.corner_radius=8 \
    background.height=26 \
    background.drawing=on \
    padding_left=4 \
    padding_right=4 \
    script="$PLUGIN_DIR/keyboard.sh" \
    click_script="$PLUGIN_DIR/keyboard_switch.sh" \
  --add event keyboard_change "AppleSelectedInputSourcesChangedNotification" \
  --subscribe keyboard keyboard_change
