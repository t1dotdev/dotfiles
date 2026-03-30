#!/bin/bash

POPUP_ITEM=(
  label.font="Berkeley Mono:Regular:12.0"
  label.color=0xccffffff
  label.padding_right=12
  icon.font="SF Pro:Bold:14.0"
  icon.color=$WHITE
  icon.padding_left=12
  icon.padding_right=8
  background.color=0x00000000
  padding_left=0
  padding_right=0
)

sketchybar --add item volume right \
  --set volume \
    icon.font="SF Pro:Bold:15.0" \
    icon.color=$WHITE \
    icon.padding_left=10 \
    icon.padding_right=10 \
    label.drawing=off \
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
    update_freq=10 \
    script="$PLUGIN_DIR/volume.sh" \
    click_script="sketchybar --set volume popup.drawing=toggle" \
  --subscribe volume volume_change system_woke mouse.exited.global front_app_switched \
  \
  --add item volume.device popup.volume \
  --set volume.device \
    "${POPUP_ITEM[@]}" \
    icon="􀊩" \
    label="Loading..." \
  \
  --add slider volume.slider popup.volume 170 \
  --set volume.slider \
    slider.highlight_color=0xffffffff \
    slider.background.color=0x40ffffff \
    slider.background.height=6 \
    slider.background.corner_radius=3 \
    padding_left=8 \
    padding_right=8 \
    script="$PLUGIN_DIR/volume_click.sh" \
  --subscribe volume.slider mouse.clicked \
  \
  --add item volume.settings popup.volume \
  --set volume.settings \
    "${POPUP_ITEM[@]}" \
    icon=􀍟 \
    label="Sound Settings..." \
    label.color=0xff8aadf4 \
    click_script="open 'x-apple.systempreferences:com.apple.preference.sound'; sketchybar --set volume popup.drawing=off" \
  \
  --add item volume.bluetooth popup.volume \
  --set volume.bluetooth \
    "${POPUP_ITEM[@]}" \
    icon=󰂯 \
    icon.font="Symbols Nerd Font Mono:Regular:14.0" \
    label="Bluetooth Settings..." \
    label.color=0xff8aadf4 \
    click_script="open /System/Library/PreferencePanes/Bluetooth.prefPane; sketchybar --set volume popup.drawing=off"
