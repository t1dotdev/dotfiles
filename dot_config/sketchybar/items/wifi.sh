#!/bin/bash

POPUP_ITEM=(
  label.font="SF Pro:Medium:12.0"
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

sketchybar --add item wifi right \
  --set wifi \
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
    update_freq=5 \
    script="$PLUGIN_DIR/wifi.sh" \
    click_script="sketchybar --set wifi popup.drawing=toggle" \
  --subscribe wifi wifi_change front_app_switched mouse.exited.global \
  \
  --add item wifi.ssid popup.wifi \
  --set wifi.ssid \
    "${POPUP_ITEM[@]}" \
    icon=􀙇 \
    label="Loading..." \
  \
  --add item wifi.ip popup.wifi \
  --set wifi.ip \
    "${POPUP_ITEM[@]}" \
    icon=􀆪 \
    label="···" \
    click_script="sketchybar --set wifi popup.drawing=off" \
  \
  --add item wifi.settings popup.wifi \
  --set wifi.settings \
    "${POPUP_ITEM[@]}" \
    icon=􀍟 \
    label="Wi-Fi Settings..." \
    label.color=0xff8aadf4 \
    click_script="open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi'; sketchybar --set wifi popup.drawing=off"
