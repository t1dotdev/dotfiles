#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

# this is jank and ugly, I know
LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"

# specify short layouts individually.
case "$LAYOUT" in
"ABC") SHORT_LAYOUT="ABC" ;;
"Thai") SHORT_LAYOUT="TH" ;;

*) SHORT_LAYOUT="?" ;;
esac

sketchybar --set keyboard label="$SHORT_LAYOUT" \
  background.color=0x00ffffff \
  background.border_color=0x33ffffff \
  background.border_width=1 \
  label.padding_left=8 \
  label.padding_right=8 \
  label.font.size=10
