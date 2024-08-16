#!/bin/bash

# sketchybar --add item network right \
# 	--set network icon=􀆪 script="$PLUGIN_DIR/network.sh" \
# 	--subscribe network wifi_change
#
#

sketchybar -m --add item network.logo right \
  --set network.logo script="$PLUGIN_DIR/network.sh" \
  label.drawing=off \
  click_script="sketchybar -m --set \$NAME popup.drawing=toggle" \
  popup.background.color=0x40000000 \
  popup.background.corner_radius=6 \
  popup.blur_radius=24 \
  --subscribe network.logo wifi_change \
  --add item network.ip popup.network.logo \
  --set network.ip script="$PLUGIN_DIR/network.sh" \
  padding_left=10 \
  padding_right=10 \
  click_script="open /System/Library/PreferencePanes/Network.prefPane; sketchybar -m --set apple.logo popup.drawing=off" \
  --subscribe network.ip wifi_change
